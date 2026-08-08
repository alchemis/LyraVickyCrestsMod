


ModCacheInjection.hook(:marts) {
  $cache.marts[:CairoRE].Inventory["Buy"].push(ItemStock.of(:LVCKRICKCREST).costs(5000, :RedEssence).limit().properties(
        conditions: [
          '$Trainer.numbadges >= 4',
          '!$game_switches[self.item]'
        ],
        on_purchase: [
          '$game_switches[item.item] = true'
        ]
      ))
}

ModCacheInjection.hook(:marts) {
  $cache.marts[:CairoRE].Inventory["Buy"].push(ItemStock.of(:LVCTSARCREST).costs(5000, :RedEssence).limit().properties(
        conditions: [
          '$Trainer.numbadges >= 8',
          '!$game_switches[self.item]'
        ],
        on_purchase: [
          '$game_switches[item.item] = true'
        ]
      ))
}

ModCacheInjection.hook(:marts) {
  $cache.marts[:CairoRE].Inventory["Buy"].push(ItemStock.of(:LVCKLINCREST).costs(5000, :RedEssence).limit().properties(
        conditions: [
          '$Trainer.numbadges >= 8',
          '!$game_switches[self.item]'
        ],
        on_purchase: [
          '$game_switches[item.item] = true'
        ]
      ))
}

ModCacheInjection.hook(:marts) {
  $cache.marts[:CairoRE].Inventory["Buy"].push(ItemStock.of(:LVCMAWCREST).costs(5000, :RedEssence).limit().properties(
        conditions: [
          '$Trainer.numbadges >= 8',
          '!$game_switches[self.item]'
        ],
        on_purchase: [
          '$game_switches[item.item] = true'
        ]
      ))
}

ModCacheInjection.hook(:marts) {
  $cache.marts[:CairoRE].Inventory["Buy"].push(ItemStock.of(:LVCZAPCREST).costs(15000, :RedEssence).limit().properties(
        conditions: [
          '$Trainer.numbadges >= 17',
          '!$game_switches[self.item]'
        ],
        on_purchase: [
          '$game_switches[item.item] = true'
        ]
      ))
}
ModCacheInjection.hook(:marts) {
  $cache.marts[:CairoRE].Inventory["Buy"].push(ItemStock.of(:LVCARTICREST).costs(15000, :RedEssence).limit().properties(
        conditions: [
          '$Trainer.numbadges >= 17',
          '!$game_switches[self.item]'
        ],
        on_purchase: [
          '$game_switches[item.item] = true'
        ]
      ))
}
ModCacheInjection.hook(:marts) {
  $cache.marts[:CairoRE].Inventory["Buy"].push(ItemStock.of(:LVCMOLCREST).costs(15000, :RedEssence).limit().properties(
        conditions: [
          '$Trainer.numbadges >= 17',
          '!$game_switches[self.item]'
        ],
        on_purchase: [
          '$game_switches[item.item] = true'
        ]
      ))
}