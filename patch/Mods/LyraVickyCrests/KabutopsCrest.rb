PBStuff::POKEMONTOCREST[:KABUTOPS] = :LVCKABUTOPSCREST


ModCacheInjection.hook(:items) {
  $cache.items[:LVCKABUTOPSCREST] = ItemData.new(:LVCKABUTOPSCREST, {
    name: "Kabutops Crest",
    desc: "If holding a Drive, Kabutops' first move becomes Techno Blast in battle. Special moves use its Attack.",
    price: 0,
    crest: true,
    keyitem: true, #NON HELD CREST
    noUseInBattle: true,
    noUse: true,
  })
}


class PokeBattle_Battler
    #look for crest in bag/trainer items instead
    alias kabucrest_hasCrest? hasCrest? if !defined?(kabucrest_hasCrest?)
    def hasCrest?(species = self.species)
        if species == :KABUTOPS then
          return true if $PokemonBag.pbQuantity(:LVCKABUTOPSCREST) > 0 && @battle.pbOwnedByPlayer?(@index) && [:BURNDRIVE,:DOUSEDRIVE,:SHOCKDRIVE,:CHILLDRIVE].include?(@item)
          return true if @battle.pbGetOwnerItems(@index).include?(:LVCKABUTOPSCREST) && !@battle.pbOwnedByPlayer?(@index) && [:BURNDRIVE,:DOUSEDRIVE,:SHOCKDRIVE,:CHILLDRIVE].include?(@item)
          return false
        else return kabucrest_hasCrest?(species)
        end
    end
    #type change
    alias kabucrest_crestStats crestStats if !defined?(kabucrest_crestStats)
    def crestStats
      
      if @crested == :KABUTOPS
          # case @item
          # when :BURNDRIVE    then @type1 = :FIRE
          # when :DOUSEDRIVE   then @type1 = :WATER
          # when :SHOCKDRIVE   then @type1 = :ELECTRIC
          # when :CHILLDRIVE   then @type1 = :ICE #just a chill guy
          # end
          #gain move
          @kabucrest_ogmove = {:move => @moves[0].move, :pp => @moves[0].pp, :totalpp => @moves[0].totalpp}
          @moves[0] = PokeBattle_Move.pbFromPBMove(@battle, PBMove.new(:TECHNOBLAST), @pokemon)
          @moves[0].pp = (@kabucrest_ogmove[:pp] * (@moves[0].totalpp.to_f / @kabucrest_ogmove[:totalpp])).floor
      end
      kabucrest_crestStats
    end
    
end

class PokeBattle_Move
  alias kabucrest_pbIsSpecial? pbIsSpecial? if !defined?(kabucrest_pbIsSpecial?)
  def pbIsSpecial?(attacker, type = @type)
    if attacker.crested == :KABUTOPS then
      return false
    else return kabucrest_pbIsSpecial?(attacker,type)
    end

  end
  alias kabucrest_pbIsPhysical? pbIsPhysical? if !defined?(kabucrest_pbIsPhysical?)
  def pbIsPhysical?(attacker, type = @type)
    if attacker.crested == :KABUTOPS then
      return true
    else return kabucrest_pbIsPhysical?(attacker,type)
    end

  end
  alias kabucrest_pbHitsSpecialStat? pbHitsSpecialStat? if !defined?(kabucrest_pbHitsSpecialStat?)
  def pbHitsSpecialStat?(attacker, type = @type)
    if attacker.crested == :KABUTOPS then
      return !(@category == :special) if @function == 0x122 #psyshock, etc
      return @category == :special #check category directly instead of calling pbIsSpecial since we overrode the behavior on that
    else return kabucrest_pbHitsSpecialStat?(attacker,type)
    end
  end
end

#Put drives axis factory
InjectionHelper.defineMapPatch(111, 64) { |event| #Axis factory, left chest
  event.patch(:ShockDrive) {
    matched = lookForAll([:Script, 'Kernel.pbItemBall(:EXPCANDYXL,3)'])
    for insn in matched
      insertBefore(insn, 
        [:Script, 'Kernel.pbItemBall(:SHOCKDRIVE)']
      )
    end
  }
}
InjectionHelper.defineMapPatch(111, 74) { |event| #Axis factory, right chest
  event.patch(:ChillDrive) {
    matched = lookForAll([:Script, 'Kernel.pbItemBall(:ADAMANTMINT)'])
    for insn in matched
      insertBefore(insn, 
        [:Script, 'Kernel.pbItemBall(:CHILLDRIVE)']
      )
    end
  }
}
InjectionHelper.defineMapPatch(111, 11) { |event| #Axis factory, statue chest
  event.patch(:BurnDrive) {
    matched = lookForAll([:Script, 'Kernel.pbItemBall(:GREENSHARD,3)'])
    for insn in matched
      insertBefore(insn, 
        [:Script, 'Kernel.pbItemBall(:BURNDRIVE)']
      )
    end
  }
}
InjectionHelper.defineMapPatch(111, 10) { |event| #Axis factory, trainchest
  event.patch(:DouseDrive) {
    matched = lookForAll([:Script, 'Kernel.pbItemBall(:YELLOWSHARD,3)'])
    for insn in matched
      insertBefore(insn, 
        [:Script, 'Kernel.pbItemBall(:DOUSEDRIVE)']
      )
    end
  }
}
InjectionHelper.defineMapPatch(111, 86) { |event| #Axis factory, master key chest
  event.patch(:DouseDrive) {
    matched = lookForAll([:Script, 'Kernel.pbItemBall(:MASTERKEY)'])
    for insn in matched
      insertBefore(insn, 
        [:Script, 'Kernel.pbItemBall(:LVCKABUTOPSCREST)']
      )
    end
  }
}