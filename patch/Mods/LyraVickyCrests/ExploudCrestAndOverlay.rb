#field stuff
# :overlay => { # effects of this field as an overlay instead of a full field #Rejuv
#   :damageMods => { # damage modifiers for specific moves, written as multipliers (e.g. 1.5 => [:TACKLE])
#   }, # a damage mod of 0 denotes the move failing on this field
#   :typeMods => { # secondary types applied to moves (written as "type" => [move1,move2,....])
#   },
#   :moveMessages => { # the field message displayed when using a move (written as "message" => [move1,move2....] )
#   },
#   :typeBoosts => { # damage multipliers applied to all moves of a specific type (e.g. 1.3 => [:FIRE,:WATER])
#   },
#   :typeMessages => { # field message shown when using a move of the denoted type ("message" => [type1,type2,....])
#   },
#   :typeCondition => { # conditions for the type boost written as a string of conditions that are evaled later
#   }, # evaled as a function on the move class
#   :statusBuffs => [], # list of non-damaging moves boosted by the field in different ways, for field highlighting (can have damaging moves too)
#   :statusNerfs => [], # list of non-damaging moves diminished by the field in different ways, for field highlighting (can have damaging moves too)
# }

# Overlay stuff
# @overlay = false
# @overlaymovedata = {}
# @overlaytypedata = {}
# @overlayStatusBuffs = []
# @overlayStatusNerfs = []
# @overlaymovemessagelist = {}
# @overlaytypemessagelist = {}

ModCacheInjection.hook(:FEData) {
  $cache.FEData[:CONCERT3].overlay = true
  $cache.FEData[:CONCERT3].overlaytypedata = {:soundmove=>{:mult=>1.3, :multtext=>1}}
  $cache.FEData[:CONCERT3].overlaytypemessagelist = $cache.FEData[:CONCERT3].typemessagelist
  $cache.FEData[:CONCERT3].overlaymovemessagelist = $cache.FEData[:CONCERT3].movemessagelist
  $cache.FEData[:CONCERT3].overlaymovedata = {
  :ACID => {:mult => 1.5,:multtext => 1,:dontchangebackup => false},
  :ACIDSPRAY => {:mult => 1.5,:multtext => 1,:dontchangebackup => false},
  :DRUMBEATING => {:mult => 1.5,:multtext => 3,:dontchangebackup => false},
  :FAKEOUT => {:mult => 1.5,:multtext => 4,:dontchangebackup => false},
  :ROLLOUT => {:mult => 1.5,:multtext => 2,:dontchangebackup => false},
  :FIRSTIMPRESSION => {:mult => 1.5,:multtext => 4,:dontchangebackup => false},
  :DRAGONTAIL => {:mult => 1.5,:multtext => 5,:dontchangebackup => false},
  :CIRCLETHROW => {:mult => 1.5,:multtext => 5,:dontchangebackup => false},
  }
  $cache.FEData[:CONCERT3].overlayStatusBuffs = [:METALSOUND, :SCREECH, :GROWL, :ENCORE] #not really used for anything but useful to keep track ig
  #Heavy Metal, Punk Rock, Rock Head, Solid Rock, Soundproof additionally boost the bearer's Defense by 1 stage on switch-in. 
  #TODO-SLEEP
}
#gen 8 howl -- removed due to mightyena crest
# class PokeBattle_Move_18E < PokeBattle_Move
#   alias_method :expcrest_pbEffectTarget, :pbEffectTarget if !defined?(expcrest_pbEffectTarget)
#   def pbEffectTarget(attacker, opponent, hitnum = 0, alltargets = nil)
#     return expcrest_pbEffectTarget(attacker, opponent, hitnum , alltargets) if !(@battle.OV == :CONCERT3)
#     opponent.pbChangeStats(PBStats::ATTACK, 2, attacker, self)
#   end
# end
# #gen 7 howl
# class PokeBattle_Move_01C < PokeBattle_Move
#   alias_method :expcrest_pbEffect, :pbEffect if !defined?(expcrest_pbEffect)
#   def pbEffect(attacker, alltargets, hitnum = 0)
#     return if @basedamage > 0
#     return expcrest_pbEffect(attacker, alltargets, hitnum ) if @move != :HOWL || @battle.OV != :CONCERT3
#     attacker.pbChangeStats(PBStats::ATTACK, 2, attacker, self, abilitycheck: :hide)
#   end
# end

#METALSOUND
class PokeBattle_Move_04F < PokeBattle_Move
  alias_method :expcrest_pbEffectTarget, :pbEffectTarget if !defined?(expcrest_pbEffectTarget)
  def pbEffectTarget(attacker, opponent, hitnum = 0, alltargets = nil)
    return true if @basedamage > 0
    return expcrest_pbEffectTarget(attacker, opponent, hitnum , alltargets) if @battle.OV != :CONCERT3 || @move != :METALSOUND
    opponent.pbChangeStats(PBStats::SPDEF, -3, attacker, self, abilitycheck: :skip)
  end
end

#screech
class PokeBattle_Move_04C < PokeBattle_Move
  alias_method :expcrest_pbEffectTarget, :pbEffectTarget if !defined?(expcrest_pbEffectTarget)
  def pbEffectTarget(attacker, opponent, hitnum = 0, alltargets = nil)
    return true if @basedamage > 0
    return expcrest_pbEffectTarget(attacker, opponent, hitnum , alltargets) if @battle.OV != :CONCERT3 || @move != :SCREECH
    opponent.pbChangeStats(PBStats::DEFENSE, -3, attacker, self, abilitycheck: :skip)
  end
end

#growl
class PokeBattle_Move_042 < PokeBattle_Move
  alias_method :expcrest_pbEffectTarget, :pbEffectTarget if !defined?(expcrest_pbEffectTarget)
  def pbEffectTarget(attacker, opponent, hitnum = 0, alltargets = nil)
    return true if @basedamage > 0
    return expcrest_pbEffectTarget(attacker, opponent, hitnum , alltargets) if @battle.OV != :CONCERT3 || @move != :GROWL
    opponent.pbChangeStats(PBStats::ATTACK, -2, attacker, self, abilitycheck: :skip)
  end
end

#roar -- removd for parity with howl
# class PokeBattle_Move_0EB < PokeBattle_Move
#   alias_method :expcrest_pbEffect, :pbEffect if !defined?(expcrest_pbEffect)
#   def pbEffect(attacker, alltargets, hitnum = 0)
#     return expcrest_pbEffect(attacker, alltargets, hitnum ) if @move != :ROAR || @battle.OV != :CONCERT3
#     attacker.pbChangeStats(PBStats::ATTACK, 2, attacker, self, abilitycheck: :hide)
#   end
# end

#encore
class PokeBattle_Move_0BC < PokeBattle_Move
  alias_method :expcrest_pbEffectTarget, :pbEffectTarget if !defined?(expcrest_pbEffectTarget)
  def pbEffectTarget(attacker, opponent, hitnum = 0, alltargets = nil)
    return expcrest_pbEffectTarget(attacker, opponent, hitnum , alltargets) if @battle.OV != :CONCERT3
    ret = expcrest_pbEffectTarget(attacker, opponent, hitnum , alltargets)
    opponent.effects[:Encore] += 3
    return ret
  end
end

PBStuff::POKEMONTOCREST[:EXPLOUD] = :LVCEXPCREST

ModCacheInjection.hook(:items) {
  $cache.items[:LVCEXPCREST] = ItemData.new(:LVCEXPCREST, {
    name: "Exploud Crest",
    desc: "Exploud starts a concert on entry, if already at a Concert Venue, maxes Hype and prevents it from dropping.",
    price: 0,
    crest: true,
    noUseInBattle: true,
    noUse: true,
  })
}
class PokeBattle_Battler
  alias_method :expcrest_pbCanSleep?, :pbCanSleep? if !defined?(expcrest_pbCanSleep?)
  def pbCanSleep?(attacker, move, ignorestatus: false, showMessage: false)
      if @battle.OV == :CONCERT3
        @battle.pbDisplay(_INTL("The concert is too loud and hype to sleep!"))
        return false
      else
        return expcrest_pbCanSleep?(attacker, move, ignorestatus: ignorestatus, showMessage: showMessage)
      end
  end

  alias_method :expcrest_pbAbilitiesOnOverlay, :pbAbilitiesOnOverlay if !defined?(expcrest_pbAbilitiesOnOverlay)
  def pbAbilitiesOnOverlay(delayStatChangeChecks = false, applySwitchInAbility: false)
    return if @applyingEntryEffects && !applySwitchInAbility
    return if self.ability.nil?
    if @battle.OV == :CONCERT3 && [:SOUNDPROOF, :PUNKROCK, :HEAVYMETAL, :SOLIDROCK, :ROCKHEAD].include?(self.ability)
      if pbCanIncreaseStatStage?(PBStats::DEFENSE, self, nil)
        @battle.pbShowAbilityBox(self)
        @battle.pbDisplay(_INTL("{1} is accustomed to the music!", pbThis))
        pbChangeStats(PBStats::DEFENSE, 1, self, nil, abilitycheck: :skip)
        @battle.pbHideAbilityBox(self)
      end
    end
    return expcrest_pbAbilitiesOnOverlay(delayStatChangeChecks, applySwitchInAbility: applySwitchInAbility)
  end
end
class PokeBattle_Battle
    alias_method :expcrest_pbOnActiveOne, :pbOnActiveOne if !defined?(expcrest_pbOnActiveOne)
    def pbOnActiveOne(pkmn)
      if @battle.OV == :CONCERT3
        if pkmn.isSleeping?
          pkmn.pbCureStatus(false) if i.status == :SLEEP   
          @battle.pbDisplay(_INTL("The Concert's noise could wake up even the dead!"))
        end
      end
      return expcrest_pbOnActiveOne(pkmn)
    end
    alias_method :expcrest_pbCrestEntry, :pbCrestEntry if !defined?(expcrest_pbCrestEntry)
    def pbCrestEntry(index, pokemon)
      expcrest_pbCrestEntry(index, pokemon)
      battler = @battlers[index]
      if battler.crested == :EXPLOUD
        case @battle.FE
        when :CONCERT1
          @battle.pbShowAbilityBox(battler)
          @battle.growField(battler.pbThis, battler,3)
          @battle.pbHideAbilityBox(battler)
        when :CONCERT2
          @battle.pbShowAbilityBox(battler)
          @battle.growField(battler.pbThis, battler,2)
          @battle.pbHideAbilityBox(battler)
        when :CONCERT3
          @battle.pbShowAbilityBox(battler)
          @battle.growField(battler.pbThis, battler,1)
          @battle.pbHideAbilityBox(battler)
        when :CONCERT4
          #nothing to do here
        else        
          return if @battle.OV == :CONCERT3 || !@battle.canChangeFE?(:CONCERT3, showMessage: true)
          pbShowAbilityBox(battler, item: true)
          @battle.pbAnimation(:MAGICROOM, battler, nil)
          @battle.setField(:CONCERT3, 3, _INTL("A crowd gathered for the concert!"))
          pbHideAbilityBox(battler)
        end
      end
    end
    alias_method :expcrest_reduceField, :reduceField if !defined?(expcrest_reduceField)
    def reduceField(times = 1)
      priority = @battle.setSpeedOrder
      noreduce = false
      for i in priority
        noreduce = true if i.crested == :EXPLOUD
      end
      if @battle.ProgressiveFieldCheck(PBFields::CONCERT, 2, 4) && noreduce
        @battle.pbDisplay(_INTL("The crowd is too excited for {1} to lose Hype!", i.pbThis))
        return false
      else 
        return expcrest_reduceField(times)
      end
    end
    alias_method :expcrest_pbEndOfRoundPhase, :pbEndOfRoundPhase if !defined?(expcrest_pbEndOfRoundPhase)
    def pbEndOfRoundPhase(skipcelebi = false)
        priority = setSpeedOrder
        for battler in priority
          if Overlays && @field.overlay && @field.effect != :FROZENDIMENSION && @battle.OV == :CONCERT3 && battler.crested == :EXPLOUD && @field.overlayCounter <= 3
              @field.overlayCounter += 1 
          end
        end
        expcrest_pbEndOfRoundPhase(skipcelebi)
    end
end


