class _BenefitsCarousel extends StatefulWidget {
  final List<PartnerBenefit> benefits;
  const _BenefitsCarousel({required this.benefits});

  @override
  State<_BenefitsCarousel> createState() => _BenefitsCarouselState();
}

class _BenefitsCarouselState extends State<_BenefitsCarousel> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 180, // Fixed height for the banner style
          child: PageView.builder(
            controller: _pageController,
            physics: const BouncingScrollPhysics(),
            itemCount: widget.benefits.length,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
            },
            itemBuilder: (context, index) {
              final benefit = widget.benefits[index];
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: context.responsive.horizontalPadding),
                child: _PartnerCard(
                  title: benefit.title,
                  desc: benefit.description,
                  color: Color(benefit.colorHex),
                  icon: _getIconFromName(benefit.iconName),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => PartnerOfferScreen(benefit: benefit)));
                  },
                  isHorizontal: true, // Always Horizontal Banner
                ),
              );
            },
          ),
        ),
        
        if (widget.benefits.length > 1) ...[
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.benefits.length, (index) {
              final isActive = _currentIndex == index;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                height: 4,
                width: isActive ? 24 : 8, // "..." Effect
                decoration: BoxDecoration(
                  color: isActive ? AppColors.primary : AppColors.textDim.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
        ],
      ],
    );
  }
}
