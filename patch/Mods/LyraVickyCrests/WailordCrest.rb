PBStuff::POKEMONTOCREST[:WAILORD] = :LVCWAILCREST


ModCacheInjection.hook(:items) {
  $cache.items[:LVCWAILCREST] = ItemData.new(:LVCWAILCREST, {
    name: "Wailord Crest",
    desc: "Increases Defenses based on current HP.",
    price: 0,
    crest: true,
    noUseInBattle: true,
    noUse: true,
  })
}

class PokeBattle_Battler
    alias wailcrest_crestStats crestStats
    def crestStats
      wailcrest_crestStats
      case @crested
        when :WAILORD
            @defense = @defense + @hp * 0.5
            @spdef = @spdef + @hp * 0.5
      end
    end
end

class Pokebattle_Battler
    alias wailcrest_pbPassiveItemHP pbPassiveItemHP
    def pbPassiveItemHP
      wailcrest_pbPassiveItemHP
      if self.crested == :WAILORD
        hpgain = (self.totalhp / 16.0).floor
      end
    end
end