# HumanProxy

- Target iOS: 17.2
- Xcode: 15.2 (15C500b)
- Platforms tested: iPhone 15 Pro (Sim)
- External Dependencies: Kingfisher

## Approach:

Consume CoinAPI, show a list of Assets on the first screen, with Icon, Full Name and ID.

When select an item, go to a Details view containing:
- Price in USD;
- Interactible chart (mocked data, 1 month);
- Exchange Rates of the current assets to other coins (Live data).

## Future Roadmap:
- [ ] Unit Testing;
- [ ] Dynamic chart;
- [ ] More chart options;
