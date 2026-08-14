PBStuff::POKEMONTOCREST[:HELIOLISK] = :LVCHELIOCREST


ModCacheInjection.hook(:items) {
  $cache.items[:LVCHELIOCREST] = ItemData.new(:LVCHELIOCREST, {
    name: "Heliolisk Crest",
    desc: "Changes its type and the type of its Normal-type moves depending on its Ability.",
    price: 0,
    crest: true,
    noUseInBattle: true,
    noUse: true,
  })
}

class PokeBattle_Move
  alias heliocrest_pbType pbType if !defined?(heliocrest_pbType)
  def pbType(attacker, type = @type)
    type = heliocrest_pbType(attacker,@type)
    if attacker.crested == :HELIOLISK && type == :NORMAL then
        case attacker.ability
          when :DRYSKIN then type = :WATER
          when :SANDVEIL then type = :GROUND
          when :SOLARPOWER then type = :FIRE
        end
    end
    return type
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
              when :SANDVEIL then @type2 = :GROUND
              when :SOLARPOWER then @type2 = :FIRE            
            end
      end
    end
end