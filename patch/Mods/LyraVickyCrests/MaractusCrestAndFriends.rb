#Form
ModCacheInjection.hook(:pkmn) {

  $cache.pkmn[:MARACTUS][0].RelearnerMoves.push(:DESERTDANCE)
  ModCacheInjection.createNewForm(:MARACTUS,"Desert Form",1,
      {
        :Type1 => :GRASS,
        :Type2 => :GROUND,
        :BaseStats => [75,106,67,86,67,60],
		    :Abilities => [:FLASHFIRE,:SANDRUSH],
        :HiddenAbility => :STORMDRAIN,
      }
  )}

#Move
ModCacheInjection.hook(:moves) {
  $cache.moves[:DESERTDANCE] = MoveData.new(:DESERTDANCE,{
    :name => "Desert Dance",
    :desc => "The target is buried in sand. It may raise the user's Sp. Atk stat. Uses the higher attacking stat.",
    :function => 0x309, #SHELL SIDE ARM
    :type => :GROUND,
    :category => :physical,
    :basedamage => 75,
    :accuracy => 100,
    :effect => 50,
    :maxpp => 15,
    :target => :SingleNonUser,
    :contact => false,
    :dancemove => true
  })

}

class PokeBattle_Move_309 < PokeBattle_Move #SHELL SIDE ARM

  def pbShowAnimation(id,attacker,opponent,hitnum=0,alltargets=nil,showanimation=true)
    if showanimation
      if id == :DESERTDANCE
        @battle.pbAnimation(:SANDTOMB,attacker,opponent,hitnum)
      else
        @battle.pbAnimation(id,attacker,opponent,hitnum)
      end
    end
  end

  alias maracrest_pbAdditionalEffect pbAdditionalEffect if !defined?(maracrest_pbAdditionalEffect)
  def pbAdditionalEffect(attacker, opponent)
    return maracrest_pbAdditionalEffect if @move != :DESERTDANCE
  end

  alias maracrest_pbAdditionalEffectSelf pbAdditionalEffectSelf if !defined?(maracrest_pbAdditionalEffectSelf)
  def pbAdditionalEffectSelf(attacker)
    return maracrest_pbAdditionalEffectSelf if @move != :DESERTDANCE
    amount = 1
    if attacker.attack > attacker.spatk then
      stat = PBStats::ATTACK
    else 
      stat = PBStats::SPATK
    end
    attacker.pbChangeStats(stat, amount, attacker, self, abilitycheck: :hide)
  end
end

#transformation
HiddenMoveHandlers::CanUseMove.add(:DESERTDANCE,lambda{|move, pkmn, showmsg|
   return pkmn.species == :MARACTUS
})

HiddenMoveHandlers::UseMove.add(:DESERTDANCE,lambda{|move, pokemon|
  pokemon.changeForm(pokemon.form == 0 ? 1 : 0)
  Kernel.pbMessage(_INTL("{1} used {2} to change its form!", pokemon.name, getMoveName(move)))
  return true
})

#Crest
PBStuff::POKEMONTOCREST[:MARACTUS] = :LVCMARACREST
ModCacheInjection.hook(:items) {
  $cache.items[:LVCMARACREST] = ItemData.new(:LVCMARACREST, {
    name: "Maractus Crest",
    desc: "Maractus's defensive stats are increased by 30% and when using a Dance move it sets up a layer of spikes.",
    price: 0,
    crest: true,
    noUseInBattle: true,
    noUse: true,
  })
}

class PokeBattle_Battler
    alias maracrest_crestStats crestStats
    def crestStats
      
      case @crested
        when :MARACTUS
          @defense *= 1.3
          @spdef *= 1.3
      end
      maracrest_crestStats
    end
end
class PokeBattle_Battler
    alias maracrest_pbResolveMoveEffects pbResolveMoveEffects if !defined?(maracrest_pbResolveMoveEffects)
    def pbResolveMoveEffects(user, basemove, targets, calcdamage, hitflag, hitcount, flags = { totaldamage: 0, UserFaintCause: [] })
      ret = maracrest_pbResolveMoveEffects(user, basemove, targets, calcdamage, hitflag, hitcount, flags)
      if user.crested == :MARACTUS && !(hitcount > 1) && $cache.moves[basemove.move]&.checkFlag?(:dancemove)
        hit_something = false
        targets.each_with_index do |target, i|
          next unless hitflag[i] == :Success
          hit_something = true
        end
        if hit_something && user.pbOpposingSide.effects[:Spikes] < 3
          @battle.pbShowAbilityBox(user, item: true)
          user.pbOpposingSide.effects[:Spikes] += 1
          if !@battle.pbIsOpposing?(user.index)
            @battle.pbDisplay(_INTL("Spikes were scattered on the ground all around the opposing team!"))
          else
            @battle.pbDisplay(_INTL("Spikes were scattered on the ground all around your team!"))
          end
          @battle.pbHideAbilityBox(user)
        end
      end
      return ret
    end
end