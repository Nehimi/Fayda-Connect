const { Telegraf, Scenes, session, Markup } = require('telegraf');
const admin = require('firebase-admin');
const serviceAccount = require('./serviceAccountKey.json');
require('dotenv').config();

// --- CONFIG ---
const ADMIN_PASSWORD = 'Sumaso4060';
const ADMIN_IDS = [5686616010, 891630138, 7008748559]; // Add your Telegram ID here

// --- FIREBASE INIT ---
if (!admin.apps.length) {
    admin.initializeApp({
        credential: admin.credential.cert(serviceAccount),
        databaseURL: "https://fayda-connect-default-rtdb.firebaseio.com"
    });
}
const db = admin.database();

// --- BOT INIT ---
const bot = new Telegraf(process.env.BOT_TOKEN);

// --- FCM HELPER ---
const sendNotification = async (title, body, type, imageUrl = '') => {
    const message = {
        notification: {
            title: title,
            body: body,
        },
        android: {
            priority: 'high',
            notification: {
                imageUrl: imageUrl || undefined,
                sound: 'default',
                channelId: 'fayda_alerts', // Target a high-importance channel
            }
        },
        apns: {
            payload: {
                aps: {
                    sound: 'default',
                },
            },
        },
        data: {
            type: type,
            click_action: 'FLUTTER_NOTIFICATION_CLICK',
        },
        topic: 'all_users',
    };

    try {
        await admin.messaging().send(message);
        console.log('Successfully sent FCM notification');
    } catch (error) {
        console.error('Error sending FCM:', error);
    }
};

// --- MIDDLEWARE ---
bot.use(session());

// Auth Middleware: Check session or admin ID
const isAdmin = (ctx) => {
    return ADMIN_IDS.includes(ctx.from.id) || (ctx.session && ctx.session.isAuthenticated);
};

bot.use(async (ctx, next) => {
    if (!ctx.session) ctx.session = {};

    // --- LOGGING (For Setup) ---
    if (ctx.from) {
        console.log(`[LOG] Msg from ${ctx.from.id} (@${ctx.from.username || 'no_user'}): ${ctx.message ? ctx.message.text : 'CallbackQuery'}`);
    }

    // 1. Always allow Callback Queries (Inline Buttons) for everyone
    if (ctx.callbackQuery) return next();

    // 2. Clear pass for /start
    if (ctx.message && ctx.message.text === '/start') return next();

    // 3. Admin check
    if (isAdmin(ctx)) return next();

    // 4. Password Check
    if (ctx.message && ctx.message.text === ADMIN_PASSWORD) {
        ctx.session.isAuthenticated = true;
        await ctx.reply('✅ Access Granted. Welcome, Admin.');
        return showMenu(ctx);
    }

    // 5. If it's a message from a non-admin, and we're not in a scene, don't let it pass to hears
    // This prevents noise, but we allow them to talk to scenes if they were in one (though they shouldn't be)
    if (ctx.message && !ctx.session.isAuthenticated) {
        // Do nothing, or maybe a tiny hint
        if (ctx.session.waitingForPassword) {
            await ctx.reply('❌ Incorrect Password. Please try again or contact support.');
            ctx.session.waitingForPassword = false;
        }
        return; // Swallow message
    }

    return next();
});

// --- KEYBOARDS ---
const mainMenu = Markup.keyboard([
    ['📰 News / Official Alert', '🤝 New Partner'],
    ['📢 Post Promotion', '🎓 Academy / Tutorial'],
    ['📝 Manage & Delete', '👤 Manage Users'],
    ['📊 App Stats', '🔔 Pending Requests'],
    ['💎 Broadcast ↔ Promo', '🎨 Toggle Pro Card'],
    ['🤝 Toggle Partners', '✨ Clear Chat'],
    ['🔥 Wipe DB']
]).resize();

const cancelMenu = Markup.keyboard([['❌ Cancel']]).resize();
const typeMenu = Markup.keyboard([['Standard', 'Premium', 'Alert'], ['❌ Cancel']]).resize();
const confirmMenu = Markup.keyboard([['✅ Confirm', '❌ Cancel']]).resize();
const userActionMenu = Markup.keyboard([['⭐ Set Premium', '🚫 Revoke Premium'], ['❌ Cancel']]).resize();

// --- HELPERS ---
const showMenu = (ctx) => ctx.reply('🤖 Fayda Connect CMS\nSelect an action:', mainMenu);

// --- SEARCH HELPER ---
async function findUsers(query) {
    const results = [];
    const searchLow = query.toLowerCase();

    // 1. Search Auth Users
    const listResult = await admin.auth().listUsers();
    listResult.users.forEach(u => {
        const nameMatch = (u.displayName && u.displayName.toLowerCase().includes(searchLow));
        const emailMatch = (u.email && u.email.toLowerCase().includes(searchLow));
        const uidMatch = u.uid === query;
        if (nameMatch || emailMatch || uidMatch) {
            results.push({ uid: u.uid, name: u.displayName || 'No Name', email: u.email || 'No Email' });
        }
    });

    // 2. Search DB (for users not in Auth or with different DB names)
    const dbSnap = await db.ref('users').once('value');
    if (dbSnap.exists()) {
        const dbUsers = dbSnap.val();
        Object.entries(dbUsers).forEach(([uid, data]) => {
            if (results.find(r => r.uid === uid)) return;
            const nameMatch = (data.name && data.name.toLowerCase().includes(searchLow));
            if (nameMatch) {
                results.push({ uid: uid, name: data.name, email: 'DB Entry' });
            }
        });
    }

    return results.slice(0, 10); // Limit to 10 for UI clarity
}

async function processUserSelection(ctx, uid) {
    try {
        const snapshot = await db.ref(`users/${uid}`).once('value');
        const userData = snapshot.val();
        let authUser = null;
        try { authUser = await admin.auth().getUser(uid); } catch (e) { }

        const message = `👤 **Member Profile**\n\n` +
            `🆔 **UID:** \`${uid}\`\n` +
            `👤 **Name:** ${authUser ? authUser.displayName : (userData ? userData.name : 'N/A')}\n` +
            `📧 **Email:** ${authUser ? authUser.email : 'N/A'}\n` +
            `💎 **Status:** ${userData && userData.isPremium ? '✅ PREMIUM MEMBER' : '❌ STANDARD MEMBER'}\n\n` +
            `Activate or revoke professional access:`;

        await ctx.replyWithMarkdown(message, userActionMenu);

        // We set the UID in session because wizards are tricky with external calls
        ctx.session.selectedUserUid = uid;
    } catch (e) {
        console.error(e);
        ctx.reply('Error loading user details.');
    }
}

// --- SCENES ---

// 1. News Wizard
const newsWizard = new Scenes.WizardScene(
    'NEWS_WIZARD',
    (ctx) => {
        ctx.reply('Enter News Title:', cancelMenu);
        return ctx.wizard.next();
    },
    (ctx) => {
        if (ctx.message.text === '❌ Cancel') return ctx.scene.leave();
        ctx.wizard.state.title = ctx.message.text;
        ctx.reply('Enter Content (Description):');
        return ctx.wizard.next();
    },
    (ctx) => {
        ctx.wizard.state.content = ctx.message.text;
        ctx.reply('Select Type:', typeMenu);
        return ctx.wizard.next();
    },
    (ctx) => {
        if (ctx.message.text === '❌ Cancel') return ctx.scene.leave();
        ctx.wizard.state.type = ctx.message.text.toLowerCase();
        ctx.reply('Enter Image URL (or type "skip"):', cancelMenu);
        return ctx.wizard.next();
    },
    (ctx) => {
        if (ctx.message.text === '❌ Cancel') return ctx.scene.leave();
        ctx.wizard.state.imageUrl = ctx.message.text.toLowerCase() === 'skip' ? '' : ctx.message.text;

        const preview = `📝 **NEWS PREVIEW**\n\n` +
            `📌 **Title:** ${ctx.wizard.state.title}\n` +
            `📄 **Type:** ${ctx.wizard.state.type}\n` +
            `🖼️ **Image:** ${ctx.wizard.state.imageUrl || 'None'}\n\n` +
            `**Content:**\n${ctx.wizard.state.content}\n\n` +
            `🚀 Post and notify all users?`;

        ctx.replyWithMarkdown(preview, confirmMenu);
        return ctx.wizard.next();
    },
    async (ctx) => {
        if (ctx.message.text === '✅ Confirm') {
            const data = {
                title: ctx.wizard.state.title,
                content: ctx.wizard.state.content,
                type: ctx.wizard.state.type,
                date: new Date().toISOString(),
                imageUrl: ctx.wizard.state.imageUrl,
                externalLink: ''
            };
            await db.ref('news_updates').push(data);

            // Send Push Notification
            await sendNotification(
                `📢 ${ctx.wizard.state.title}`,
                ctx.wizard.state.content.substring(0, 100) + '...',
                ctx.wizard.state.type,
                ctx.wizard.state.imageUrl
            );

            await ctx.reply('✅ News Posted & Notification Sent!');
        } else {
            await ctx.reply('❌ Post Cancelled.');
        }
        return ctx.scene.leave();
    }
);

// 2. Partner Wizard
const benefitWizard = new Scenes.WizardScene(
    'BENEFIT_WIZARD',
    (ctx) => {
        ctx.reply('Enter Partner Name (Title):', cancelMenu);
        return ctx.wizard.next();
    },
    (ctx) => {
        if (ctx.message.text === '❌ Cancel') return ctx.scene.leave();
        ctx.wizard.state.title = ctx.message.text;
        ctx.reply('Enter Description:');
        return ctx.wizard.next();
    },
    (ctx) => {
        ctx.wizard.state.desc = ctx.message.text;
        ctx.reply('Enter Icon Name (e.g., percent, gift, award):');
        return ctx.wizard.next();
    },
    (ctx) => {
        ctx.wizard.state.icon = ctx.message.text;
        ctx.reply('Enter Color Hex (e.g., 0xFF0000):');
        return ctx.wizard.next();
    },
    async (ctx) => {
        const data = {
            title: ctx.wizard.state.title,
            description: ctx.wizard.state.desc,
            iconName: ctx.wizard.state.icon,
            colorHex: parseInt(ctx.message.text),
            features: [],
            deepLink: ''
        };
        await db.ref('partner_benefits').push(data);
        await ctx.reply('✅ Partner Added!');
        return ctx.scene.leave();
    }
);

// 3. Promotion Wizard
const promotionWizard = new Scenes.WizardScene(
    'PROMOTION_WIZARD',
    (ctx) => {
        ctx.reply('Enter Promotion Title:', cancelMenu);
        return ctx.wizard.next();
    },
    (ctx) => {
        if (ctx.message.text === '❌ Cancel') return ctx.scene.leave();
        ctx.wizard.state.title = ctx.message.text;
        ctx.reply('Enter Content:');
        return ctx.wizard.next();
    },
    (ctx) => {
        ctx.wizard.state.content = ctx.message.text;
        ctx.reply('Enter Image URL (Imgur link):');
        return ctx.wizard.next();
    },
    (ctx) => {
        ctx.wizard.state.image = ctx.message.text;
        ctx.reply('Enter Action Link (URL):');
        return ctx.wizard.next();
    },
    (ctx) => {
        ctx.wizard.state.link = ctx.message.text;
        const preview = `📢 **PROMOTION PREVIEW**\n\n` +
            `📌 **Title:** ${ctx.wizard.state.title}\n` +
            `🔗 **Link:** ${ctx.wizard.state.link}\n\n` +
            `**Content:**\n${ctx.wizard.state.content}\n\n` +
            `🚀 Blast this promotion to all users?`;

        ctx.replyWithMarkdown(preview, confirmMenu);
        return ctx.wizard.next();
    },
    async (ctx) => {
        if (ctx.message.text === '✅ Confirm') {
            const data = {
                title: ctx.wizard.state.title,
                content: ctx.wizard.state.content,
                type: 'promotion',
                date: new Date().toISOString(),
                imageUrl: ctx.wizard.state.image,
                externalLink: ctx.wizard.state.link
            };
            await db.ref('news_updates').push(data);

            // Send Push Notification
            await sendNotification(
                `✨ ${ctx.wizard.state.title}`,
                ctx.wizard.state.content.substring(0, 100) + '...',
                'promotion',
                ctx.wizard.state.image
            );

            await ctx.reply('🚀 Promotion Live & Notified!');
        } else {
            await ctx.reply('❌ Promotion Cancelled.');
        }
        return ctx.scene.leave();
    }
);


// 4. Academy Wizard
const academyWizard = new Scenes.WizardScene(
    'ACADEMY_WIZARD',
    (ctx) => {
        ctx.reply('🎓 Enter Video Title:', cancelMenu);
        return ctx.wizard.next();
    },
    (ctx) => {
        if (ctx.message.text === '❌ Cancel') return ctx.scene.leave();
        ctx.wizard.state.title = ctx.message.text;
        ctx.reply('Enter Description:');
        return ctx.wizard.next();
    },
    (ctx) => {
        ctx.wizard.state.content = ctx.message.text;
        ctx.reply('Enter YouTube Video Link:');
        return ctx.wizard.next();
    },
    async (ctx) => {
        const videoLink = ctx.message.text;
        const data = {
            title: ctx.wizard.state.title,
            content: ctx.wizard.state.content,
            type: 'academy', // Specific type for Academy
            date: new Date().toISOString(),
            imageUrl: videoLink, // We store video link in imageUrl field as per app logic
            externalLink: videoLink
        };
        await db.ref('news_updates').push(data);
        await ctx.reply('🎓 Academy Video Posted!');
        return ctx.scene.leave();
    }
);

// 5. Edit Post Wizard (Non-linear entry)
const editPostWizard = new Scenes.WizardScene(
    'EDIT_POST_WIZARD',
    async (ctx) => {
        if (!ctx.wizard.state.postId) {
            ctx.wizard.state.postId = ctx.scene.state.postId;
        }
        ctx.reply('✏️ **EDIT MODE**\n\nEnter new **Title** (or type "skip" to keep current):', cancelMenu);
        return ctx.wizard.next();
    },
    (ctx) => {
        if (ctx.message.text === '❌ Cancel') return ctx.scene.leave();
        ctx.wizard.state.newTitle = ctx.message.text;
        ctx.reply('Enter new **Content** (or type "skip" to keep current):');
        return ctx.wizard.next();
    },
    async (ctx) => {
        const updates = {};
        if (ctx.wizard.state.newTitle.toLowerCase() !== 'skip') updates.title = ctx.wizard.state.newTitle;
        if (ctx.message.text.toLowerCase() !== 'skip') updates.content = ctx.message.text;

        if (Object.keys(updates).length > 0) {
            await db.ref('news_updates/' + ctx.wizard.state.postId).update(updates);
            await ctx.reply('✅ Post Updated Successfully!');
        } else {
            await ctx.reply('No changes made.');
        }
        return ctx.scene.leave();
    }
);

// 6. User Management Wizard (ELITE VERSION)
const userManageWizard = new Scenes.WizardScene(
    'USER_MANAGE_WIZARD',
    (ctx) => {
        ctx.reply('👤 **User Search**\nEnter Name, Email, or UID:', cancelMenu);
        return ctx.wizard.next();
    },
    async (ctx) => {
        if (ctx.message.text === '❌ Cancel') return ctx.scene.leave();
        const query = ctx.message.text.trim();

        ctx.reply('🔍 Searching...');
        const matches = await findUsers(query);

        if (matches.length === 0) {
            ctx.reply('❌ No users found. Please try another search.');
            return ctx.scene.leave();
        }

        if (matches.length === 1) {
            await processUserSelection(ctx, matches[0].uid);
            return ctx.wizard.next();
        }

        // Multiple Matches
        const buttons = matches.map(m => [Markup.button.callback(`${m.name} (${m.email.substring(0, 5)}...)`, `sel_user_${m.uid}`)]);
        ctx.reply('👥 Multiple matches found. Select one:', Markup.inlineKeyboard(buttons));
        return ctx.wizard.next();
    },
    async (ctx) => {
        // Handling input
        if (ctx.message && ctx.message.text === '❌ Cancel') return ctx.scene.leave();

        // Final Action Step for User Manager
        const action = ctx.message.text;
        const uid = ctx.session.selectedUserUid;
        if (!uid) return ctx.scene.leave();

        if (action === '⭐ Set Premium' || action === '🚫 Revoke Premium') {
            const isPremium = action === '⭐ Set Premium';
            await db.ref(`users/${uid}`).update({ isPremium: isPremium });
            await db.ref(`premium_requests/${uid}`).remove();
            await ctx.reply(isPremium ? `✅ User ACTIVATED!` : `🚫 Status RESTORED to Standard.`);
            return ctx.scene.leave();
        }
    }
);

const stage = new Scenes.Stage([newsWizard, benefitWizard, promotionWizard, academyWizard, editPostWizard, userManageWizard]);
bot.use(stage.middleware());

// --- COMMANDS ---

bot.start(async (ctx) => {
    if (isAdmin(ctx)) {
        return showMenu(ctx);
    }

    const supportMsg = `👋 **Welcome to Fayda Connect Support**\n\n` +
        `This is the official identity verification bot. How can we help you today?\n\n` +
        `🇪🇹 **የፋይዳ ኮኔክት ድጋፍ ሰጪ ቦት**\n` +
        `እንኳን ወደ ፋይዳ ኮኔክት የድጋፍ መስጫ ቦት በደህና መጡ። እንዴት ልንረዳዎ እንችላለን?`;

    const userKeyboard = Markup.inlineKeyboard([
        [Markup.button.callback('🛡️ How to Activate', 'user_how_to')],
        [Markup.button.callback('📞 Contact Agent', 'user_contact')],
        [Markup.button.callback('🔒 Admin Login', 'user_admin_login')]
    ]);

    await ctx.replyWithMarkdown(supportMsg, userKeyboard);
});

bot.action('user_admin_login', (ctx) => {
    ctx.session.waitingForPassword = true;
    ctx.reply('🔑 Please enter the Admin Password to access the management dashboard:');
    ctx.answerCbQuery();
});

bot.action('user_how_to', (ctx) => {
    const text = `ℹ️ **How to Activate Pro Access**\n\n` +
        `1. Open Fayda Connect App\n` +
        `2. Go to **"Professional Status"** in the side menu\n` +
        `3. Copy your **User ID**\n` +
        `4. Click **"Request Activation"** on that page\n\n` +
        `Our team will review your ID and activate your status within 24 hours!`;
    ctx.replyWithMarkdown(text);
    ctx.answerCbQuery();
});

bot.action('user_contact', (ctx) => {
    ctx.reply(`👨‍💻 For direct assistance, please contact our support lead: @NehimiG2`);
    ctx.answerCbQuery();
});

bot.hears('📰 News / Official Alert', (ctx) => ctx.scene.enter('NEWS_WIZARD'));
bot.hears('🤝 New Partner', (ctx) => ctx.scene.enter('BENEFIT_WIZARD'));
bot.hears('📢 Post Promotion', (ctx) => ctx.scene.enter('PROMOTION_WIZARD'));
bot.hears('🎓 Academy / Tutorial', (ctx) => ctx.scene.enter('ACADEMY_WIZARD'));
bot.hears('👤 Manage Users', (ctx) => ctx.scene.enter('USER_MANAGE_WIZARD'));

bot.hears('🔔 Pending Requests', async (ctx) => {
    const snapshot = await db.ref('premium_requests').once('value');
    if (!snapshot.exists()) return ctx.reply('✅ No pending requests.');

    const requests = snapshot.val();
    let text = '🔔 **Pending Activation Requests**\n\n';
    const buttons = [];

    Object.entries(requests).forEach(([uid, data]) => {
        text += `👤 **${data.name}**\n🆔 \`${uid}\`\n\n`;
        buttons.push([Markup.button.callback(`✅ Approve ${data.name.split(' ')[0]}`, `approve_req_${uid}`)]);
    });

    ctx.replyWithMarkdown(text, Markup.inlineKeyboard(buttons));
});

// --- CALLBACK HANDLERS ---
bot.action(/^sel_user_(.+)$/, async (ctx) => {
    const uid = ctx.match[1];
    await ctx.answerCbQuery();
    await processUserSelection(ctx, uid);
});

bot.action(/^approve_req_(.+)$/, async (ctx) => {
    const uid = ctx.match[1];
    await db.ref(`users/${uid}`).update({ isPremium: true });
    await db.ref(`premium_requests/${uid}`).remove();
    await ctx.editMessageText(`✅ User \`${uid}\` approved manually.`);
    await ctx.answerCbQuery('User Activated!');
});

// --- STATS HANDLER ---
bot.hears('📊 App Stats', async (ctx) => {
    try {
        const loadingMsg = await ctx.reply('📊 Calculating stats...');
        const usersResult = await admin.auth().listUsers();
        const totalUsersCount = usersResult.users.length;

        const usersSnapshot = await db.ref('users').once('value');
        let premiumCount = 0;
        if (usersSnapshot.exists()) {
            const users = usersSnapshot.val();
            premiumCount = Object.values(users).filter(u => u.isPremium === true).length;
        }

        const newsSnapshot = await db.ref('news_updates').once('value');
        const totalPosts = newsSnapshot.exists() ? Object.keys(newsSnapshot.val()).length : 0;

        const statsText = `📊 **Fayda Connect Insights**\n\n` +
            `👥 **Total Users:** ${totalUsersCount}\n` +
            `⭐ **Premium Members:** ${premiumCount}\n` +
            `📰 **Live Posts:** ${totalPosts}\n\n` +
            `Built with ❤️ by Fayda Team`;

        await ctx.telegram.editMessageText(ctx.chat.id, loadingMsg.message_id, null, statsText, { parse_mode: 'Markdown' });
    } catch (e) {
        console.error(e);
        ctx.reply('❌ Error fetching stats.');
    }
});

// --- MANAGE POSTS HANDLERS ---
bot.hears('📝 Manage & Delete', async (ctx) => {
    try {
        const snapshot = await db.ref('news_updates').limitToLast(10).once('value');
        const data = snapshot.val();
        if (!data) return ctx.reply('📭 No posts found.');

        const buttons = [];
        const entries = Object.entries(data).reverse();

        entries.forEach(([key, value]) => {
            const label = value.title.length > 20 ? value.title.substring(0, 20) + '...' : value.title;
            const typeEmoji = value.type === 'academy' ? '🎓' : (value.type === 'promotion' ? '📢' : '📰');
            buttons.push([Markup.button.callback(`${typeEmoji} ${label}`, `manage_post_${key}`)]);
        });

        ctx.reply('📝 **Select a post to manage:**', Markup.inlineKeyboard(buttons));
    } catch (e) {
        ctx.reply('Error fetching posts.');
    }
});

bot.action(/^manage_post_(.+)$/, async (ctx) => {
    try {
        const postId = ctx.match[1];
        const snapshot = await db.ref(`news_updates/${postId}`).once('value');
        const post = snapshot.val();

        if (!post) {
            return ctx.reply('❌ Post not found.');
        }

        const message = `📌 **${post.title}**\n\n${post.content}\n\nType: ${post.type}\nDate: ${new Date(post.date).toLocaleDateString()}`;

        await ctx.reply(message, Markup.inlineKeyboard([
            [Markup.button.callback('✏️ Edit', `edit_post_${postId}`), Markup.button.callback('🗑️ Delete', `delete_post_${postId}`)]
        ]));
    } catch (e) {
        console.error(e);
    }
    await ctx.answerCbQuery();
});

bot.action(/^delete_post_(.+)$/, async (ctx) => {
    const postId = ctx.match[1];
    await db.ref(`news_updates/${postId}`).remove();
    await ctx.reply('🗑️ Post Deleted.');
    await ctx.answerCbQuery();
});

bot.action(/^edit_post_(.+)$/, async (ctx) => {
    const postId = ctx.match[1];
    await ctx.answerCbQuery();
    await ctx.scene.enter('EDIT_POST_WIZARD', { postId: postId });
});

bot.hears('💎 Broadcast ↔ Promo', async (ctx) => {
    const ref = db.ref('settings/hide_premium_news');
    const snapshot = await ref.once('value');
    const current = snapshot.val() === true;
    await ref.set(!current);
    ctx.reply(!current ? '💎 Switched to: PROMO MODE\n(Broadcasts are hidden, default Pro message is shown.)' : '💎 Switched to: BROADCAST MODE\n(Latest Premium News will be shown in the header.)');
});

bot.hears('🎨 Toggle Pro Card', async (ctx) => {
    const ref = db.ref('settings/show_premium_promo');
    const snapshot = await ref.once('value');
    const current = snapshot.val() !== false;
    await ref.set(!current);
    ctx.reply(!current ? '✅ Pro Card is now VISIBLE.' : '🚫 Pro Card is now HIDDEN.');
});

bot.hears('🤝 Toggle Partners', async (ctx) => {
    const ref = db.ref('settings/show_partners');
    const snapshot = await ref.once('value');
    const current = snapshot.val() !== false;
    await ref.set(!current);
    ctx.reply(!current ? '✅ Partners Section is now VISIBLE.' : '🚫 Partners Section is now HIDDEN.');
});

bot.hears('✨ Clear Chat', async (ctx) => {
    try {
        for (let i = 0; i < 100; i++) {
            await ctx.deleteMessage(ctx.message.message_id - i).catch(() => { });
        }
    } catch (e) { }
    ctx.reply('✨ Chat Cleared (fresh start)');
});

bot.hears('🔥 Wipe DB', async (ctx) => {
    ctx.reply('⚠️ Use /confirm_wipe to delete ALL database data.');
});

bot.command('confirm_wipe', async (ctx) => {
    await db.ref('news_updates').remove();
    await db.ref('partner_benefits').remove();
    ctx.reply('🔥 Database Wiped.');
});

bot.action('cancel', (ctx) => ctx.scene.leave());

// --- LIVE REQUEST LISTENER ---
db.ref('premium_requests').on('child_added', (snapshot) => {
    const uid = snapshot.key;
    const data = snapshot.val();

    ADMIN_IDS.forEach(async (id) => {
        try {
            const msg = `🚨 **NEW ACTIVATION REQUEST** 🚨\n\n` +
                `👤 **Name:** ${data.name}\n` +
                `📧 **Email:** ${data.email}\n` +
                `🆔 **UID:** \`${uid}\`\n\n` +
                `Directly approve this user?`;

            await bot.telegram.sendMessage(id, msg, {
                parse_mode: 'Markdown',
                ...Markup.inlineKeyboard([
                    [Markup.button.callback('✅ APPROVE NOW', `approve_req_${uid}`)]
                ])
            });
        } catch (e) { }
    });
});

bot.launch().then(() => console.log('🤖 Admin Bot Started'));
process.once('SIGINT', () => bot.stop('SIGINT'));
process.once('SIGTERM', () => bot.stop('SIGTERM'));
