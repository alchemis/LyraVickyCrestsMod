PBStuff::POKEMONTOCREST[:HELIOLISK] = :LVCHELIOCREST


ModCacheInjection.hook(:items) {
  $cache.items[:LVCHELIOCREST] = ItemData.new(:LVCHELIOCREST, {
    name: "Heliolisk Crest",
    desc: "Heliolisk's Normal-Type and Normal moves change to match the Type of its Ability.",
    price: 0,
    crest: true,
    noUseInBattle: true,
    noUse: true,
  })
}

class PokeBattle_Move
  alias heliocrest_pbType pbType if !defined?(heliocrest_pbType)
  def pbType(attacker, type = @type)
    type = heliocrest_pbType(attacker,type)
    if attacker.crested == :HELIOLISK && type == :NORMAL then
        case attacker.ability
          when :DRYSKIN then type = :WATER
          when :SANDVEIL then type = :ROCK
          when :SOLARPOWER then type = :FIRE
        end
    end
    return type
  end
end
#shadowbuffing to match -ate abilities
class PokeBattle_Move
    alias heliocrest_pbCalcDamage pbCalcDamage if !defined?(heliocrest_pbCalcDamage)
    def pbCalcDamage(attacker, opponent, hitnum = 0, feedbackMessages = { opponent.index => [] }, movetype: nil)
    damage = heliocrest_pbCalcDamage(attacker, opponent, hitnum, feedbackMessages, movetype: movetype)
      if attacker.crested == :HELIOLISK && @type == :NORMAL #@type is original move type
        damage = (damage*1.2).floor
      end
    return damage
    end
end

class PokeBattle_Battler
    alias heliocrest_crestStats crestStats if !defined?(heliocrest_crestStats)
    def crestStats
      heliocrest_crestStats
      case @crested
        when :HELIOLISK
            case @ability
              when :DRYSKIN then @type2 = :WATER
              when :SANDVEIL then @type2 = :ROCK
              when :SOLARPOWER then @type2 = :FIRE            
            end
      end
    end
end