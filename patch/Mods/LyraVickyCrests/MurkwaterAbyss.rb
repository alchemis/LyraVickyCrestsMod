def lvc_makefield(data)
  #taken from compiler
  fieldMessages = []
  currentfield = FEData.new
  # Basic data copying
  currentfield.name = data[:name]
  fieldMessages.push data[:name]
  currentfield.fieldAppSwitch = data[:fieldAppSwitch]
  currentfield.message = data[:fieldMessage]
  fieldMessages.push data[:fieldMessage]
  currentfield.secretPower = data[:secretPower]
  currentfield.graphic = data[:graphic]
  currentfield.naturePower = data[:naturePower]
  currentfield.mimicry = data[:mimicry]
  currentfield.burmyCloak = data[:burmyCloak]
  currentfield.statusBuffs = data[:statusBuffs]
  currentfield.statusNerfs = data[:statusNerfs]
  currentfield.overlayStatusBuffs = data[:overlay][:statusBuffs] if data[:overlay]
  currentfield.overlayStatusNerfs = data[:overlay][:statusNerfs] if data[:overlay]
  # now for worse shit
  # invert hashes such that move => mod
  movetypemod = pbHashForwardizer(data[:typeMods]) || {}
  movedamageboost = pbHashForwardizer(data[:damageMods]) || {}
  moveaccuracyboost = pbHashForwardizer(data[:accuracyMods]) || {}
  counterincreases = pbHashForwardizer(data[:fieldCounterIncreases]) || {}
  moveeffects = pbHashForwardizer(data[:moveEffects]) || {}
  typedamageboost = pbHashForwardizer(data[:typeBoosts]) || {}
  typetypemod = pbHashForwardizer(data[:typeAddOns]) || {}
  fieldchange = pbHashForwardizer(data[:fieldChange]) || {}
  changeeffects = pbHashForwardizer(data[:changeEffects]) || {}
  typecondition = data[:typeCondition] ? data[:typeCondition] : {}
  typeeffects = data[:typeEffects] ? data[:typeEffects] : {}
  changecondition = data[:changeCondition] ? data[:changeCondition] : {}
  dontchangebackup = data[:dontChangeBackup] ? data[:dontChangeBackup] : {}
  if data[:overlay]
    overlaydamage = pbHashForwardizer(data[:overlay][:damageMods]) || {}
    overlaytypemod = pbHashForwardizer(data[:overlay][:typeMods]) || {}
    overlaytypeboost = pbHashForwardizer(data[:overlay][:typeBoosts]) || {}
    overlaytypecons = data[:overlay][:typeCondition] ? data[:overlay][:typeCondition] : {}
  end

  # messages get stored separately and are replaced by an index
  movemessages  = data[:moveMessages]  || {}
  typemessages  = data[:typeMessages]  || {}
  changemessage = data[:changeMessage] || {}
  overlaymovemsg = data[:overlay][:moveMessages] || {} if data[:overlay]
  overlaytypemsg = data[:overlay][:typeMessages] || {} if data[:overlay]
  movemessagelist = []
  typemessagelist = []
  changemessagelist = []
  olmovemessagelist = []
  oltypemessagelist = []
  messagearray = [movemessages, typemessages, changemessage]
  messagearray = [movemessages, typemessages, changemessage, overlaymovemsg, overlaytypemsg] if data[:overlay]
  messagearray.each_with_index { |hashdata, index|
    messagelist = hashdata.keys
    fieldMessages.push *messagelist
    newhashdata = {}
    hashdata.each { |key, value|
      newhashdata[messagelist.index(key) + 1] = value
    }
    invhash = pbHashForwardizer(newhashdata)
    case index
      when 0
        movemessagelist = messagelist
        movemessages = invhash
      when 1
        typemessagelist = messagelist
        typemessages = invhash
      when 2
        changemessagelist = messagelist
        changemessage = invhash
      when 3
        olmovemessagelist = messagelist
        overlaymovemsg = invhash
      when 4
        oltypemessagelist = messagelist
        overlaytypemsg = invhash
    end
  }

  # now we have all our hashes de-backwarded, and can fuse them all together.
  # first, moves:
  # get all the keys in one place
  keys = (movedamageboost.keys << movetypemod.keys << moveaccuracyboost.keys << counterincreases.keys << moveeffects.keys << fieldchange.keys).flatten
  # now we take all the old hashes and squish them into one:
  fieldmovedata = {}
  for move in keys
    movedata = {}
    movedata[:mult] = movedamageboost[move] if movedamageboost[move]
    movedata[:typemod] = movetypemod[move] if movetypemod[move]
    movedata[:accmod] = moveaccuracyboost[move] if moveaccuracyboost[move]
    movedata[:multtext] = movemessages[move] if movemessages[move]
    movedata[:counterincrease] = counterincreases[move] if counterincreases[move]
    movedata[:moveeffect] = moveeffects[move] if moveeffects[move]
    movedata[:fieldchange] = fieldchange[move] if fieldchange[move]
    movedata[:changetext] = changemessage[move] if changemessage[move]
    movedata[:changeeffect] = changeeffects[move] if changeeffects[move]
    movedata[:dontchangebackup] = dontchangebackup.include?(move)
    fieldmovedata[move] = movedata
  end
  # now, types!
  fieldtypedata = {}
  keys = (typedamageboost.keys << typetypemod.keys << typeeffects.keys).flatten
  for type in keys
    typedata = {}
    typedata[:mult] = typedamageboost[type] if typedamageboost[type]
    typedata[:typemod] = typetypemod[type] if typetypemod[type]
    typedata[:typeeffect] = typeeffects[type] if typeeffects[type]
    typedata[:multtext] = typemessages[type] if typemessages[type]
    typedata[:condition] = typecondition[type] if typecondition[type]
    fieldtypedata[type] = typedata
  end
  if data[:overlay]
    overlaymovedata = {}
    keys = (overlaydamage.keys << overlaytypemod.keys).flatten
    for move in keys
      movedata = {}
      movedata[:mult] = overlaydamage[move] if overlaydamage[move]
      movedata[:typemod] = overlaytypemod[move] if overlaytypemod[move]
      movedata[:multtext] = overlaymovemsg[move] if overlaymovemsg[move]
      overlaymovedata[move] = movedata
    end
    overlaytypedata = {}
    keys = overlaytypeboost.keys
    for type in keys
      typedata = {}
      typedata[:mult] = overlaytypeboost[type] if overlaytypeboost[type]
      typedata[:multtext] = overlaytypemsg[type] if overlaytypemsg[type]
      typedata[:condition] = overlaytypecons[type] if overlaytypecons[type]
      overlaytypedata[type] = typedata
    end
  end

  # seeds for good measure.
  seeddata = data[:seed]
  fieldMessages.push seeddata[:message] if seeddata[:message]
  currentfield.fieldtypedata = fieldtypedata
  currentfield.fieldmovedata = fieldmovedata
  currentfield.seeddata = seeddata
  currentfield.movemessagelist = movemessagelist
  currentfield.typemessagelist = typemessagelist
  currentfield.changemessagelist = changemessagelist
  currentfield.fieldchangeconditions = changecondition
  currentfield.overlay = true if data[:overlay] && ![0, nil, :INDOOR].include?(key)
  currentfield.overlaytypedata = overlaytypedata if overlaytypedata
  currentfield.overlaymovedata = overlaymovedata if overlaymovedata
  currentfield.overlaymovemessagelist = olmovemessagelist if olmovemessagelist
  currentfield.overlaytypemessagelist = oltypemessagelist if oltypemessagelist
  MessageTypes.addMessagesAsHash(:FieldMessages, fieldMessages)
  # all done!
  return currentfield
end

#$game_variables[:Forced_Field_Effect] = :MURKWATERABYSS

ModCacheInjection.hook(:FEData) {

$cache.FEData[:MURKWATERABYSS] = lvc_makefield({
    :name => "Murkwater Abyss",
    :fieldAppSwitch => 2022, # idk for now
    :fieldMessage => "The abyss is tainted...",
    :graphic => ["MurkwaterAbyss"],
    :secretPower => :SLUDGEBOMB,
    :naturePower => :SLUDGEWAVE,
    :mimicry => :POISON,
    :burmyCloak => :TRASHCLOAK,
    :damageMods => {
      1.5 => [:WATERPULSE, :JETPUNCH, :ACID, :ACIDSPRAY, :BRINE, :APPLEACID],
      2.0 => [:ANCHORSHOT, :DRAGONDARTS],
      0 => [:TARSHOT, :SPICYEXTRACT],
    },
    :accuracyMods => {},
    :moveMessages => {
      "Jet-streamed!" => [:WATERPULSE, :JETPUNCH],
      "The toxic abyss strengthened the attack!" => [:ACID, :ACIDSPRAY, :APPLEACID],
      "Stinging!" => [:BRINE],
      "From the depths!" => [:ANCHORSHOT, :DRAGONDARTS],
      "The tar washed off instantly!" => [:TARSHOT],
      "The extract washed away!" => [:SPICYEXTRACT],
    },
    :typeMods => {
      # :WATER => [:DRAGONDARTS, :GRAVAPPLE],
    },
    :typeAddOns => {
      :POISON => [:WATER,:GROUND],
      :WATER => [:POISON,:GROUND],
    },
    :fieldCounterIncreases => {
      [1, 2, 2, "The water is being purified!"] => [:PURIFY,:SEEDFLARE],
    },
    :moveEffects => {},
    :typeBoosts => {
      1.5 => [:WATER, :POISON],
      2.0 => [:ELECTRIC],
      0 => [:FIRE],
    },
    :typeMessages => {
      "The toxic water strengthened the attack!" => [:WATER, :POISON], 
      "The toxic water super-conducted the attack!" => [:ELECTRIC],
      "...But the attack was doused instantly!" => [:FIRE],
    },
    :typeCondition => {},
    :typeEffects => {},
    :changeCondition => {
      :UNDERWATER => "@battle.field.counter > 1",
    },
    :fieldChange => {
      :MURKWATERSURFACE => [:DIVE, :SKYDROP, :FLY, :BOUNCE, :SHOREUP, :TRIPLEDIVE],
      # :UNDERWATER => [:PURIFY],
    },
    :dontChangeBackup => [],
    :changeMessage => {
      "The battle resurfaced!" => [:DIVE, :SKYDROP, :FLY, :BOUNCE, :SHOREUP, :TRIPLEDIVE],
      #"The attack cleared the waters!" => [:PURIFY],
    },
    :statusBuffs => [:AQUARING, :TAKEHEART, :OCTOLOCK, :TOXIC, :SMOG, :POISONGAS, :POISONPOWDER],
    :statusNerfs => [*PBStuff::WEATHERMOVE, *PBStuff::TERRAINMOVE],
    :changeEffects => {
      # "@battle.waterPollution" => [:SLUDGEWAVE, :ACIDDOWNPOUR], dunno what this is
    },
    :seed => {
      :seedtype => :ELEMENTALSEED,
      :effect => nil,
      :duration => 0,
      :message => "{1} absorbed toxins!", #badly poison user also
      :animation => :TOXIC,
      :stats => {
        PBStats::SPEED => 1,
        PBStats::SPATK => 1,
      },
    }
  }
)}
TOTALFIELDS += 1 #add this when field notes
FieldIDToSym[99] = :MURKWATERABYSS


class PokeBattle_Battle
  alias_method :murkabyss_pbEndOfRoundPhase, :pbEndOfRoundPhase if !defined?(murkabyss_pbEndOfRoundPhase)
  def pbEndOfRoundPhase(skipcelebi = false)
    murkabyss_pbEndOfRoundPhase(skipcelebi)
    if @field.effect == :MURKWATERABYSS
      priority = setSpeedOrder
      for battler in priority
        next if battler.isFainted?
        typemod = battler.murkwaterabyssPassiveDamage
        if !typemod.immune?
          mult = typemod.multiplier
          battler.pbReduceHP((battler.totalhp / 8.0 * mult).floor, true, message: _INTL("The toxic water hurt {1}!", battler.pbThis))
          battler.pbFaint if battler.isFainted?
        end
      end
    end
      
  end
end

class PokeBattle_Battler
  
  def murkwaterabyssPassiveDamage #returns typemod
    return Typemod.zero if hasType?(:POISON)
    return Typemod.zero if @ability == :IMMUNITY || @ability == :MAGICGUARD || @ability == :PASTELVEIL || @ability == :POISONHEAL || @ability == :SURGESURFER || @ability == :TOXICBOOST || @ability == :WONDERGUARD || @ability == :STORMDRAIN || @ability == :SWIFTSWIM
    if self.isbossmon
      return Typemod.zero if self.immunities[:fieldEffectDamage].include?(@battle.FE)
    end
    #why.
    pokemonDummy = PokeBattle_Pokemon.new(:DITTO, 1)
    battlerDummy = PokeBattle_Battler.new(@battle, @battle.battlers.length, true)
    battlerDummy.pbInitPokemon(pokemonDummy, @battle.battlers.length)
    moveDummy = PokeBattle_Move_FFF.new(@battle, battlerDummy, :WATER)
    #has a poison subtype already because of the field, dont need to do a separate check for poison
    typemod = moveDummy.pbCalcTypeMod(:WATER, battlerDummy, self)
    typemod *= Typemod.double if @ability == :FLAMEBODY || @ability == :MAGMAARMOR || @ability == :WATERABSORB
    typemod *= Typemod.double if @effects[:TwoTurnAttack] && @effects[:TwoTurnAttack] == :DIVE
    typemod *= Typemod.half if hasType?(:WATER) #water takes half chip

    return typemod
  end

  #reduce nonpoison spdef by 1 stage
  alias_method :murkabyss_pbAbilitiesOnField, :pbAbilitiesOnField if !defined?(murkabyss_pbAbilitiesOnField)
  def pbAbilitiesOnField(delayStatChangeChecks = false, applySwitchInAbility: false)
      if !applySwitchInAbility
        return if @battle.preSurgeField && @battle.FE == @battle.preSurgeField
        return if @applyingEntryEffects
      end
      ret = murkabyss_pbAbilitiesOnField(delayStatChangeChecks, applySwitchInAbility: applySwitchInAbility)
      if !hasType?(:POISON) && @ability != :PASTELVEIL && @ability != :POISONHEAL && @ability != :IMMUNITY
        if pbCanReduceStatStage?(PBStats::SPDEF, self, self, showMessage: false)
          @battle.pbDisplay(_INTL("The abyss corrodes {1}'s defenses!", pbThis))
          pbChangeStats(PBStats::SPDEF, -1, self, self, abilitycheck: :skip)
        end
      end
      return ret
  end
end

#steel can be poisoned
CodeInjector.replace_in_method(:PokeBattle_Battler, :pbCanPoison?, "when (hasType?(:POISON) || hasType?(:STEEL)) && attacker&.ability != :CORROSION && !([:CORROSIVE, :CORROSIVEMIST].include?(@battle.FE) && attacker&.ability == :TOXICCHAIN) then failure = :Type", 
"when ((hasType?(:POISON) || hasType?(:STEEL)) && attacker&.ability != :CORROSION && !([:CORROSIVE, :CORROSIVEMIST].include?(@battle.FE) && attacker&.ability == :TOXICCHAIN)) && !(@battle.FE == :MURKWATERABYSS && hasType?(:STEEL)) then failure = :Type")

#non-water speed
CodeInjector.replace_in_method(:PokeBattle_Battler,:pbSpeed, "when :UNDERWATER",
 "when :UNDERWATER, :MURKWATERABYSS"
)

#weather stuff
CodeInjector.replace_in_method(:PokeBattle_Battle,:noWeather, "elsif @field.effect == :UNDERWATER",
 "elsif @field.effect == :UNDERWATER || @field.effect = :MURKWATERABYSS"
)
CodeInjector.replace_in_method(:PokeBattle_Battle,:canSetWeather?, "elsif @field.effect == :UNDERWATER",
 "elsif @field.effect == :UNDERWATER || @field.effect = :MURKWATERABYSS"
)

#typemod stuff
CodeInjector.insert_in_method_before(:PokeBattle_Move,:pbTypeModifier, "if @battle.FE == :HOLY",
 "if @battle.FE == :MURKWATERABYSS
    mod = Typemod.normal if [:STEEL, :ROCK].include?(opptype) && atype == :POISON
    mod = Typemod.normal if opptype == :WATER && atype == :WATER
  end"
)

#elec acc
CodeInjector.replace_in_method(:PokeBattle_Move,:pbCalcAccuracy, "return -1 if @battle.FE == :UNDERWATER && pbType(attacker) == :ELECTRIC",
 "return -1 if (@battle.FE == :UNDERWATER || @battle.FE == :MURKWATERABYSS) && pbType(attacker) == :ELECTRIC"
)