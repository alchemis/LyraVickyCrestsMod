ModCacheInjection.hook(:marts) {
  $cache.marts[:LVCShop] = MartData.new(:LVCShop,
  {
    :Messages => {
      :welcome => "CRESTIE: Need monies for gambling! Please buy lots!",
      :goodbye => "CRESTIE: No... Please buy more!",
      :anything_else => "CRESTIE: You like buying crests don't you?",

      :no_items => "CRESTIE: No moneys?! No gamble :(",
      :nothing_to_buy => "CRESTIE: Have nothing left to sell... Sorgy!",
      :purchase_confirm_single => "CRESTIE: You like buying crests don't you?",

      :success_items => "CRESTIE: $_$"
    },
    :Inventory => [
      ItemStock.of(:LVCKRICKCREST).costs(10000).limit().properties(conditions: ['!searchItem(self.item) && $Trainer.numbadges >= 2']),
      ItemStock.of(:LVCHELIOCREST).costs(10000).limit().properties(conditions: ['!searchItem(self.item) && $Trainer.numbadges >= 2']),
      ItemStock.of(:LVCMARACREST).costs(10000).limit().properties(conditions: ['!searchItem(self.item) && $Trainer.numbadges >= 2']),

      
      ItemStock.of(:LVCROSECREST).costs(40000).limit().properties(conditions: ['!searchItem(self.item) && $Trainer.numbadges >= 4']),
      ItemStock.of(:LVCSPIDCREST).costs(40000).limit().properties(conditions: ['!searchItem(self.item) && $Trainer.numbadges >= 4']),
      ItemStock.of(:LVCPYROARCREST).costs(40000).limit().properties(conditions: ['!searchItem(self.item) && $Trainer.numbadges >= 4']),
      
      ItemStock.of(:LVCRAICHUCREST).costs(60000).limit().properties(conditions: ['!searchItem(self.item) && $Trainer.numbadges >= 6']),
      ItemStock.of(:LVCKLINCREST).costs(60000).limit().properties(conditions: ['!searchItem(self.item) && $Trainer.numbadges >= 6']),
      ItemStock.of(:LVCBIBACREST).costs(60000).limit().properties(conditions: ['!searchItem(self.item) && $Trainer.numbadges >= 6']),
      ItemStock.of(:LVCWAILCREST).costs(60000).limit().properties(conditions: ['!searchItem(self.item) && $Trainer.numbadges >= 6']),

      ItemStock.of(:LVCSLAKCREST).costs(80000).limit().properties(conditions: ['!searchItem(self.item) && $Trainer.numbadges >= 8']),
      ItemStock.of(:LVCTSARCREST).costs(80000).limit().properties(conditions: ['!searchItem(self.item) && $Trainer.numbadges >= 8']),
      ItemStock.of(:LVCNOIVCREST).costs(80000).limit().properties(conditions: ['!searchItem(self.item) && $Trainer.numbadges >= 8']),
      
      ItemStock.of(:LVCTYRACREST).costs(100000).limit().properties(conditions: ['!searchItem(self.item) && $Trainer.numbadges >= 10']),
      ItemStock.of(:LVCAUROCREST).costs(100000).limit().properties(conditions: ['!searchItem(self.item) && $Trainer.numbadges >= 10']),
      ItemStock.of(:LVCJMPLFFCREST).costs(100000).limit().properties(conditions: ['!searchItem(self.item) && $Trainer.numbadges >= 10']),
      ItemStock.of(:LVCBRELCREST).costs(100000).limit().properties(conditions: ['!searchItem(self.item) && $Trainer.numbadges >= 10']),
      ItemStock.of(:LVCEXPCREST).costs(100000).limit().properties(conditions: ['!searchItem(self.item) && $Trainer.numbadges >= 10']),
      ItemStock.of(:LVCARCHCREST).costs(120000).limit().properties(conditions: ['!searchItem(self.item) && $Trainer.numbadges >= 12']),
      ItemStock.of(:LVCCARRACREST).costs(120000).limit().properties(conditions: ['!searchItem(self.item) && $Trainer.numbadges >= 12']),
      ItemStock.of(:LVCNINETALESCREST).costs(120000).limit().properties(conditions: ['!searchItem(self.item) && $Trainer.numbadges >= 12']),
      ItemStock.of(:LVCATALESCREST).costs(120000).limit().properties(conditions: ['!searchItem(self.item) && $Trainer.numbadges >= 12']),
      ItemStock.of(:LVCALTACREST).costs(120000).limit().properties(conditions: ['!searchItem(self.item) && $Trainer.numbadges >= 12']),

      ItemStock.of(:LVCTREVCREST).costs(140000).limit().properties(conditions: ['!searchItem(self.item) && $Trainer.numbadges >= 14']),
      ItemStock.of(:LVCMAWCREST).costs(140000).limit().properties(conditions: ['!searchItem(self.item) && $Trainer.numbadges >= 14']),
      ItemStock.of(:LVCMIGHTYCREST).costs(140000).limit().properties(conditions: ['!searchItem(self.item) && $Trainer.numbadges >= 14']),

      ItemStock.of(:LVCSTCREST).costs(160000).limit().properties(conditions: ['!searchItem(self.item) && $Trainer.numbadges >= 16']),
      ItemStock.of(:LVCHAXCREST).costs(160000).limit().properties(conditions: ['!searchItem(self.item) && $Trainer.numbadges >= 16']),
      #ItemStock.of(:LVCGARDECREST).costs(160000).limit().properties(conditions: ['!searchItem(self.item) && $Trainer.numbadges >= 16']),
      #^ moved to shayda

      ItemStock.of(:LVCARTICREST).costs(250000).limit().properties(conditions: ['!searchItem(self.item) && $Trainer.numbadges >= 18']),
      ItemStock.of(:LVCZAPCREST).costs(250000).limit().properties(conditions: ['!searchItem(self.item) && $Trainer.numbadges >= 18']),
      ItemStock.of(:LVCMOLCREST).costs(250000).limit().properties(conditions: ['!searchItem(self.item) && $Trainer.numbadges >= 18']),
    ]
  }
  )
}

InjectionHelper.defineMapPatch(434) { # Luck's Tent
  createNewEvent(8, 12, "crestie", "crestie") { #On the left couch
    newPage {
      @step_anime = true
      @always_on_top = true
      requiresSwitch 5 #gym 2 defeated
      setGraphic 'pkmn_marshadow', direction: :Right, hueShift: 240 
      interact {
        text "CRESTIE: Hi! Buy crests?"
        script "pbComplexMart(:LVCShop)"          
        
      }
    }
  }
}


#Shayda ng+ shop
ModCacheInjection.hook(:marts) {
  $cache.marts[:ShaydaShop].Inventory["Buy"].push(ItemStock.of(:LVCGARDECREST).costs(2, :UMBRALSHARD).limit().properties(conditions: ['!searchItem(self.item)']))
}