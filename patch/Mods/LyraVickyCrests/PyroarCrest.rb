PBStuff::POKEMONTOCREST[:PYROAR] = :LVCPYROARCREST


ModCacheInjection.hook(:items) {
  $cache.items[:LVCPYROARCREST] = ItemData.new(:LVCPYROARCREST, {
    name: "Pyroar Crest",
    desc: "Pyroar's ATK becomes equal to its Sp.ATK, also its defenses are boosted by 20%.",
    price: 0,
    crest: true,
    noUseInBattle: true,
    noUse: true,
  })
}

class PokeBattle_Battler
    alias_method :pyroarcrest_crestStats, :crestStats if !defined?(pyroarcrest_crestStats)
    def crestStats
      
      case @crested
        when :PYROAR
            @attack = @spatk
            @defense *= 1.2
            @spdef *= 1.2
      end
      pyroarcrest_crestStats
    end
end

# Maybe add something to with sound moves? I know you suggested making them all Roar...
