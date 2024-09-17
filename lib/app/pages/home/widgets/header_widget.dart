import 'package:cosmic_jump/app/widgets/app_snackbar.dart';
import 'package:cosmic_jump/app/widgets/button.dart';
import 'package:cosmic_jump/constants/app_colors.dart';
import 'package:cosmic_jump/data/repositories/account_repository.dart';
import 'package:cosmic_jump/data/resources/account.dart';
import 'package:cosmic_jump/data/resources/characters.dart';
import 'package:flutter/material.dart';

class HeaderWidget extends StatefulWidget {
  const HeaderWidget({super.key});

  @override
  State<HeaderWidget> createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  final OverlayPortalController _tooltipController = OverlayPortalController();
  final _link = LayerLink();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: CompositedTransformTarget(
        link: _link,
        child: OverlayPortal(
          controller: _tooltipController,
          overlayChildBuilder: (BuildContext context) {
            return CompositedTransformFollower(
              link: _link,
              targetAnchor: Alignment.bottomLeft,
              child: Align(
                alignment: AlignmentDirectional.topStart,
                child: Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.lightBlue2,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 5,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 12, 8, 12),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 14),
                                child:
                                    Image.asset('assets/images/HUD/Coin.png'),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                account.coins.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: characters.map((character) {
                              final isPurchased = account.unlockedCharacters
                                  .contains(character);

                              return GestureDetector(
                                onTap: () {
                                  if (!isPurchased) {
                                    _showDialog(character);
                                    return;
                                  }
                                  setState(() {
                                    account.currentCharacter = character;
                                    AccountRepository.instance.save(account);
                                  });
                                },
                                child: Stack(
                                  children: [
                                    Image.asset(
                                      'assets/images/Characters/$character/Preview.png',
                                      width: 54,
                                    ),
                                    if (!isPurchased)
                                      Positioned(
                                        right: 4,
                                        bottom: 4,
                                        child: Icon(
                                          Icons.lock_rounded,
                                          color: Colors.red[600],
                                          size: 20,
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
          child: GestureDetector(
            onTap: _tooltipController.toggle,
            child: Row(
              children: [
                SizedBox.square(
                  dimension: 56,
                  child: DecoratedBox(
                    // decorate as the circle avatar
                    decoration: const BoxDecoration(
                      color: AppColors.lightBlue2,
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Image.asset(
                        'assets/images/Characters/${account.currentCharacter}/Preview.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bem vindo,',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      'Astronauta',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDialog(String character) {
    showDialog<void>(
      context: context,
      builder: (context) => ColoredBox(
        color: Colors.transparent,
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.lightBlue2,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 5,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Comprar $character?',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 14),
                      child: Image.asset('assets/images/HUD/Coin.png'),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${charactersPrices[character]}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Button(
                      text: 'Comprar',
                      isDense: true,
                      onPressed: () {
                        final price = charactersPrices[character]!;
                        if (account.coins < price) {
                          Navigator.of(context).pop();
                          const AppSnackbar('Moedas insuficientes')
                              .show(context);

                          return;
                        }

                        setState(() {
                          account.coins -= price;
                          account.unlockedCharacters.add(character);
                          AccountRepository.instance.save(account);
                        });
                        Navigator.of(context).pop();
                      },
                    ),
                    const SizedBox(width: 10),
                    Button(
                      text: 'Cancelar',
                      isDense: true,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
