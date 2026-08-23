PBStuff::POKEMONTOCREST[:ZAPDOS] = :LVCZAPCREST


ModCacheInjection.hook(:items) {
  $cache.items[:LVCZAPCREST] = ItemData.new(:LVCZAPCREST, {
    name: "Zapdos Crest",
    desc: "Zapdos causes it to rain for 8 turns on entry, also its Electric moves can hit Ground-Types in the rain.",
    price: 0,
    crest: true,
    noUseInBattle: true,
    noUse: true,
  })
}
class PokeBattle_Battler
    #only works for base form
    alias zapcrest_hasCrest? hasCrest? if !defined?(zapcrest_hasCrest?)
    def hasCrest?(species = self.species)
        if species == :ZAPDOS && @item == :LVCZAPCREST && @form != 0 then
          return false
        else return zapcrest_hasCrest?(species)
        end
    end
end
class PokeBattle_Move
  alias zapcrest_irregularTypeMods irregularTypeMods if !defined?(zapcrest_irregularTypeMods)
  def irregularTypeMods(attacker, opponent, typemod, type)
    typemod = zapcrest_irregularTypeMods(attacker, opponent, typemod, type)
    case attacker.crested
      when :ZAPDOS
        if @battle.pbWeather(attacker) == :RAINDANCE then
          typemod = Typemod.normal if [:ELECTRIC].include?(type) and opponent.types.include?(:GROUND)
        end
    end
    return typemod
  end
end

class PokeBattle_Battle
    alias zapcrest_pbCrestEntry pbCrestEntry if !defined?(zapcrest_pbCrestEntry)
    def pbCrestEntry(index, pokemon)
      zapcrest_pbCrestEntry(index, pokemon)
      battler = @battlers[index]
      case battler.crested
        when :ZAPDOS
          return if !canSetWeather?(:RAINDANCE)
          duration = [:CLOUDS, :SKY].include?(@field.effect) ? 11 : 8
          pbShowAbilityBox(battler, item: true)
          pbSetWeather(:RAINDANCE, duration)
          pbHideAbilityBox(battler)
      end
    end
end