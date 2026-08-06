
ModCacheInjection.hook(:marts) {
  $cache.marts[:CairoRE].Inventory["Buy"].push(ItemStock.of(:LVCMAWCREST).costs(5000, :RedEssence).limit().properties(
        conditions: [
          '$Trainer.numbadges >= 12',
          '!$game_switches[self.item]'
        ],
        on_purchase: [
          '$game_switches[item.item] = true'
        ]
      ))
}

ModCacheInjection.hook(:marts) {
  $cache.marts[:CairoRE].Inventory["Buy"].push(ItemStock.of(:LVCKRICKCREST).costs(5000, :RedEssence).limit().properties(
        conditions: [
          '$Trainer.numbadges >= 2',
          '!$game_switches[self.item]'
        ],
        on_purchase: [
          '$game_switches[item.item] = true'
        ]
      ))
}