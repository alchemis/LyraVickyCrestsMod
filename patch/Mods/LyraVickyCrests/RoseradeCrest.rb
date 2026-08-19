PBStuff::POKEMONTOCREST[:ROSERADE] = :LVCROSECREST


ModCacheInjection.hook(:items) {
  $cache.items[:LVCROSECREST] = ItemData.new(:LVCROSECREST, {
    name: "Roserade Crest",
    desc: "Roserade's Physical and Special stats are swapped and its Speed increased by 15%.",
    price: 0,
    crest: true,
    noUseInBattle: true,
    noUse: true,
  })
}

class PokeBattle_Battler
    alias rosecrest_crestStats crestStats if !defined?(rosecrest_crestStats)
    def crestStats
      rosecrest_crestStats
      case @crested
        when :ROSERADE
            @attack, @spatk = @spatk, @attack
            @defense, @spdef = @spdef,defense
            @speed *= 1.15
      end
    end

    alias rosecrest_pbGetHitNumber pbGetHitNumber if !defined?(rosecrest_pbGetHitNumber)
    def pbGetHitNumber(basemove, norandomness: false)
        if self.crested == :ROSERADE then
          if [0x0C0, 0x307].include?(basemove.function) # Bullet Seed (and all other 2-5 multihits with no special effect), Scale Shot
            if norandomness then
              return 4
            else
              return @battle.sample([4, 5])
            end
          elsif basemove.function == 0x50A #pop bomb
            return 10
          end
        end

        norandomness = false if !defined=(norandomness)
        return rosecrest_pbGetHitNumber(basemove, norandomness: norandomness)
    end
end

# I want to add an unlisted part that makes multihits hit 4-5 times, but can't figure it out, so please help me Lyra.
# there you go