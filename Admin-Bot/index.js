const { Telegraf, Scenes, session, Markup } = require('telegraf');
const admin = require('firebase-admin');
const serviceAccount = require('./serviceAccountKey.json');
require('dotenv').config();

// --- CONFIG ---
const ADMIN_PASSWORD = 'Sumaso4060';
const ADMIN_IDS = [5686616010, 891630138]; // Add your Telegram ID here

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

// --- MIDDLEWARE ---
bot.use(session());

// Auth Middleware: Check session or admin ID
const isAdmin = (ctx) => {
    return ADMIN_IDS.includes(ctx.from.id) || (ctx.session && ctx.session.isAuthenticated);
};

bot.use(async (ctx, next) => {
    if (!ctx.session) ctx.session = {};

    // Skip auth for start command to allow password entry
    if (ctx.message && ctx.message.text === '/start') return next();

    // Check Auth
    if (isAdmin(ctx)) {
        return next();
    }

    // Password Check
    if (ctx.message && ctx.message.text === ADMIN_PASSWORD) {
        ctx.session.isAuthenticated = true;
        await ctx.reply('✅ Access Granted. Welcome, Admin.');
        return showMenu(ctx);
    }

    if (ctx.message && ctx.message.text) {
        await ctx.reply('🔒 Restricted Access. Enter Admin Password:');
    }
});

// --- KEYBOARDS ---
const mainMenu = Markup.keyboard([
    ['🚀 New Update', '🤝 New Partner'],
    ['📢 Post Promotion', '👀 View Status'],
    ['👁️ Toggle Pro Promo', '🤝 Toggle Partners'],
    ['✨ Clear Chat', '🔥 Wipe DB']
]).resize();

const cancelMenu = Markup.keyboard([['❌ Cancel']]).resize();

// --- HELPERS ---
const showMenu = (ctx) => ctx.reply('🤖 Fayda Connect CMS\nSelect an action:', mainMenu);

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
        ctx.reply('Enter Type (standard, premium, alert):');
        return ctx.wizard.next();
    },
    (ctx) => {
        ctx.wizard.state.type = ctx.message.text.toLowerCase();
        ctx.reply('Enter Image URL (any direct link) or type "skip":');
        return ctx.wizard.next();
    },
    async (ctx) => {
        let imageUrl = ctx.message.text;
        if (imageUrl.toLowerCase() === 'skip') imageUrl = '';

        const data = {
            title: ctx.wizard.state.title,
            content: ctx.wizard.state.content,
            type: ctx.wizard.state.type,
            date: new Date().toISOString(),
            imageUrl: imageUrl,
            externalLink: ''
        };
        await db.ref('news_updates').push(data);
        await ctx.reply('✅ News Posted!');
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
    async (ctx) => {
        const data = {
            title: ctx.wizard.state.title,
            content: ctx.wizard.state.content,
            type: 'promotion',
            date: new Date().toISOString(),
            imageUrl: ctx.wizard.state.image,
            externalLink: ctx.message.text
        };
        await db.ref('news_updates').push(data);
        await ctx.reply('🚀 Promotion Live!');
        return ctx.scene.leave();
    }
);

const stage = new Scenes.Stage([newsWizard, benefitWizard, promotionWizard]);
bot.use(stage.middleware());

// --- COMMANDS ---

bot.start((ctx) => {
    if (isAdmin(ctx)) {
        return showMenu(ctx);
    }
    ctx.reply('🔒 Admin System Locked. Enter Password:');
});

bot.hears('🚀 New Update', (ctx) => ctx.scene.enter('NEWS_WIZARD'));
bot.hears('🤝 New Partner', (ctx) => ctx.scene.enter('BENEFIT_WIZARD'));
bot.hears('📢 Post Promotion', (ctx) => ctx.scene.enter('PROMOTION_WIZARD'));

bot.hears('👁️ Toggle Pro Promo', async (ctx) => {
    const ref = db.ref('settings/show_premium_promo');
    const snapshot = await ref.once('value');
    const current = snapshot.val() !== false; // Default true

    await ref.set(!current);
    ctx.reply(!current ? '✅ Pro Promo is now VISIBLE.' : '🚫 Pro Promo is now HIDDEN.');
});

bot.hears('🤝 Toggle Partners', async (ctx) => {
    const ref = db.ref('settings/show_partners');
    const snapshot = await ref.once('value');
    const current = snapshot.val() !== false; // Default true

    await ref.set(!current);
    ctx.reply(!current ? '✅ Partners Section is now VISIBLE.' : '🚫 Partners Section is now HIDDEN.');
});

bot.hears('✨ Clear Chat', async (ctx) => {
    try {
        // Loop to delete last 100 messages (approx)
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

// Start Bot
bot.launch().then(() => console.log('🤖 Admin Bot Started'));

// Enable graceful stop
process.once('SIGINT', () => bot.stop('SIGINT'));
process.once('SIGTERM', () => bot.stop('SIGTERM'));
