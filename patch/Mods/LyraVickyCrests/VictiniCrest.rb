

PBStuff::POKEMONTOCREST[:VICTINI] = :LVCVICCREST

ModCacheInjection.hook(:items) {
  $cache.items[:LVCVICCREST] = ItemData.new(:LVCVICCREST, {
    name: "Victini Crest",
    desc: "Victini gains STAB with Ice- and Electric-type moves. Uses two-turn moves immediately.",
    price: 0,
    crest: true,
    noUseInBattle: true,
    noUse: true,
  })
}
class PokeBattle_Move
  alias viccrest_pbModifySTAB pbModifySTAB if !defined?(viccrestpbModifySTAB)
  def pbModifySTAB(stabmult, type, attacker, opponent)
    if attacker.crested == :VICTINI then
        stabmult += 0.5 if [:ICE, :ELECTRIC].include?(type)
    end
    return viccrest_pbModifySTAB(stabmult, type, attacker, opponent)
  end
end


#Charge
#message
class PokeBattle_Battler
    alias viccrest_pbUseMove pbUseMove if !defined?(viccrest_pbUseMove)
    def pbUseMove(choice, flags = { danced: false, totaldamage: 0, specialusage: false, specialZ: false }) 
          user = self
          if user.crested == :VICTINI then
            user.effects[:PowerHerb] = :Crest
          end
      return viccrest_pbUseMove(choice,flags)
    end
end

#solarbeam
class PokeBattle_Move_0C4 < PokeBattle_Move
    alias viccrest_pbTwoTurnAttack pbTwoTurnAttack if !defined?(viccrest_pbTwoTurnAttack)
    def pbTwoTurnAttack(attacker)
      if attacker.effects[:TwoTurnAttack] == 0 && attacker.crested == :VICTINI then
        @immediate = true
        attacker.effects[:PowerHerb] = :Crest
        return true
      end
      return viccrest_pbTwoTurnAttack(attacker)
    end
end

#bounce
class PokeBattle_Move_0CC < PokeBattle_Move
    alias viccrest_pbTwoTurnAttack pbTwoTurnAttack if !defined?(viccrest_pbTwoTurnAttack)
    def pbTwoTurnAttack(attacker)
      if attacker.effects[:TwoTurnAttack] == 0 && attacker.crested == :VICTINI then
        @immediate = true
        attacker.effects[:PowerHerb] = :Crest
        return true
      end
      return viccrest_pbTwoTurnAttack(attacker)
    end
end

#freezeshock
class PokeBattle_Move_0C5 < PokeBattle_Move
    alias viccrest_pbTwoTurnAttack pbTwoTurnAttack if !defined?(viccrest_pbTwoTurnAttack)
    def pbTwoTurnAttack(attacker)
      if attacker.effects[:TwoTurnAttack] == 0 && attacker.crested == :VICTINI then
        @immediate = true
        attacker.effects[:PowerHerb] = :Crest
        return true
      end
      return viccrest_pbTwoTurnAttack(attacker)
    end
end

#iceburn
class PokeBattle_Move_0C6 < PokeBattle_Move
    alias viccrest_pbTwoTurnAttack pbTwoTurnAttack if !defined?(viccrest_pbTwoTurnAttack)
    def pbTwoTurnAttack(attacker)
      if attacker.effects[:TwoTurnAttack] == 0 && attacker.crested == :VICTINI then
        @immediate = true
        attacker.effects[:PowerHerb] = :Crest
        return true
      end
      return viccrest_pbTwoTurnAttack(attacker)
    end
end
