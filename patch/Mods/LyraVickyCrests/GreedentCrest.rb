PBStuff::POKEMONTOCREST[:GREEDENT] = :LVCGREEDCREST


ModCacheInjection.hook(:items) {
  $cache.items[:LVCGREEDCREST] = ItemData.new(:LVCGREEDCREST, {
    name: "Greedent Crest",
    desc: "Greedent's berry is restored once per turn. Gains type resistances according to the berry eaten.",
    price: 0,
    crest: true,
    keyitem: true, #NON HELD CREST
    noUseInBattle: true,
    noUse: true,
  })
}
class PokeBattle_Battler
    alias_method :greedcrest_hasCrest?, :hasCrest? if !defined?(greedcrest_hasCrest?)
    def hasCrest?(species = self.species)
        if species == :GREEDENT then
          return true if $PokemonBag.pbQuantity(:LVCGREEDCREST) > 0 && @battle.pbOwnedByPlayer?(@index)
          return true if @battle.pbGetOwnerItems(@index).include?(:LVCGREEDCREST) && !@battle.pbOwnedByPlayer?(@index)
          return false
        else return greedcrest_hasCrest?(species)
        end
    end

    alias_method :greedcrest_pbEatBerry, :pbEatBerry if !defined?(greedcrest_pbEatBerry)
    def pbEatBerry(berry = nil, animation: true)
        ret = greedcrest_pbEatBerry(berry, animation: animation)
        berry = self.item if berry.nil?
        @effects[:lvc_greedcrest_berry] = berry
        return ret
    end
end

class PokeBattle_Battle
  alias_method :greedcrest_pbEndOfRoundPhase, :pbEndOfRoundPhase if !defined?(greedcrest_pbEndOfRoundPhase)
  def pbEndOfRoundPhase(skipcelebi = false)
      priority = setSpeedOrder
      for i in priority
        if pbIsBerry?(i.permeffs[:ItemRecycle]) && i.crested == :GREEDENT
          i.item = i.permeffs[:ItemRecycle]
          i.permeffs[:ItemToKeep] = i.permeffs[:ItemRecycle]
          i.permeffs[:ItemRecycle] = nil
          message = _INTL("{1} found {2}!", i.pbThis, getItemName(i.item, :a))
          pbShowAbilityBox(i, item: true, attrname: getItemName(:LVCGREEDCREST), crest: true)
          pbDisplay(message)
          @battle.pbHideAbilityBox(i)
          i.pbBerryHerbCheck
        end
      end
      greedcrest_pbEndOfRoundPhase(skipcelebi)
  end
end

        
                  
class PokeBattle_Move
  alias_method :greedcrest_irregularTypeMods, :irregularTypeMods if !defined?(greedcrest_irregularTypeMods)
  def irregularTypeMods(attacker, opponent, typemod, type)
    typemod = greedcrest_irregularTypeMods(attacker, opponent, typemod, type)
    if opponent.crested == :GREEDENT && defined?(opponent.effects[:lvc_greedcrest_berry] ) && opponent.effects[:lvc_greedcrest_berry] && pbNaturalGiftType(opponent.effects[:lvc_greedcrest_berry]) != :NORMAL
        typemod *= Typemod.half if PBTypes.oneTypeEff(type, pbNaturalGiftType(opponent.effects[:lvc_greedcrest_berry]), inverse: @battle.inverse?).resisted?
        typemod = Typemod.zero if PBTypes.oneTypeEff(type, pbNaturalGiftType(opponent.effects[:lvc_greedcrest_berry]), inverse: @battle.inverse?).immune?
    end
    return typemod
  end
end