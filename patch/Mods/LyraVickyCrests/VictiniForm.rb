if !(File.exist?('patch/Init/0000.cache_injection.rb') or !File.exist?('patch/Init/0000.map_injection.rb')) then 
  print("Error, patching libraries not found. Please download 0000.cache_injection.rb and 0000.map_injection.rb from wiresegal's modpack at: github.com/yrsegal/rejuvenation-modpack")
end

#Forms
ModCacheInjection.hook(:pkmn) {

  $cache.pkmn[:VICTINI][0,1].RelearnerMoves.push(:CELEBRATE, :FREEZESHOCK, :ICEBURN, :VICTORYDANCE, :VDEVASTATE)
  ModCacheInjection.createNewForm(:VICTINI,"Promised Victory",1,
      {
        :Type1 => :FAIRY,
        :Type2 => :FIRE,
        :BaseStats => [110, 120, 80, 120, 80, 110],
		    :Abilities => [:VICTORYSTAR],
        :ExcludeDex => true,
      }
  )}

#Move
ModCacheInjection.hook(:moves) {
  $cache.moves[:VDEVASTATE] = MoveData.new(:VDEVASTATE,{
    :name => "V-devastate",
    :desc => "Uses the light of a promised Victory to devastate the opponent. Uses the highest attacking stat.",
    :function => 0x309, #SHELL SIDE ARM
    :type => :FAIRY,
    :category => :physical,
    :basedamage => 180,
    :accuracy => 100,
    :maxpp => 5,
    :target => :SingleNonUser,
    :contact => false,
    # :dancemove => true #NO
  })

}

class PokeBattle_Move_309 < PokeBattle_Move #SHELL SIDE ARM
  alias_method :vicform_pbShowAnimation, :pbShowAnimation if !defined?(vicform_pbShowAnimation)
  def pbShowAnimation(id,attacker,opponent,hitnum=0,alltargets=nil,showanimation=true)
    if showanimation
      if id == :VDEVASTATE
        @battle.pbAnimation(:JUDGMENTFAIRY,attacker,opponent,hitnum)
      else
        vicform_pbShowAnimation(id,attacker,opponent,hitnum,alltargets,showanimation)
      end
    end
  end
  alias_method :vicform_pbEffect, :pbEffect if !defined?(vicform_pbEffect)
  def pbEffect(attacker, alltargets, hitnum = 0)
    if @move == :VDEVASTATE
      attacker.pbChangeStats([PBStats::DEFENSE, PBStats::SPDEF, PBStats::SPEED], -1, attacker, self, abilitycheck: :hide)
    else return #vicform_pbEffect(attacker,alltargets,hitnum)
    end
  end
end