class PokeBattle_Battle
  def pbLVC_OpposingCrestCheck(mon,crest)
    for battler in @battlers
        next if battler.isFainted?
        next if !battler.pbIsOpposing?(mon.index)
        next if battler == mon
        return true if battler.crested == crest
    end
    return false
  end
end



#Boss reward stuff
class PokemonSummaryScene
    alias_method :lvc_drawPageOne, :drawPageOne if !method_defined?(:lvc_drawPageOne)
    def drawPageOne(pokemon)
        if pokemon.flickerOT then
          ot = pokemon.ot.dup
          pokemon.ot = pokemon.getflickerOT(ot)
        end
        ret = lvc_drawPageOne(pokemon)
        pokemon.ot = ot if defined?(ot) && pokemon.flickerOT
        return ret
    end
end
class PokeBattle_Pokemon
  attr_accessor :flickerOT
  def getflickerOT(oot=@ot)
    return @ot if !@flickerOT
    @flickerOT[:timer] += 1
    return @flickerOT[:display] if @flickerOT[:timer] < @flickerOT[:interval]
    @flickerOT[:timer] = 0
    if rand(100) < @flickerID[:weight]
      @flickerOT[:display] = @flickerOT[:OTList].sample
    else
      @flickerOT[:display] = @ot
    end
    return @flickerOT[:display]
  end
end

def lvc_make_flicker(arr, amt, incl_real = false, chance: 50, use_all_chars: false)
    flicker_arr = []
    flicker_chars = ["$","#","!","%","/","=","+","&"]
    for item in arr
        flicker_arr.push(item) if incl_real
        for _ in 0..amt
            curr = item.dup()
            curr = curr.chars()
            for i in 0..(curr.length-1)
              curr[i] = flicker_chars.sample() if curr[i] != " " && chance > rand(99) && !use_all_chars
              curr[i] = rand(33..126).chr if curr[i] != " " && chance > rand(99) && use_all_chars
            end
            flicker_arr.push(curr.join)
        end
    end
    return flicker_arr
end

def lvc_testsuperboss(rene = false)
    pbDoubleTrainerBattle(:LVCVICTORY,"Victory",1,"",:LVCLYRA,"Lyra",1,"",true) if rene
    pbDoubleTrainerBattle(:LVCVICTORY,"Victory",0,"",:LVCLYRA,"Lyra",0,"",true) if !rene
end

def lvc_givebossreward(rene = false)
  poke=PokeBattle_Pokemon.new(:VICTINI,100,$Trainer,false)
  poke.changeForm(1) if rene
  poke.pbLearnMove(rene ? :VDEVASTATE : :VCREATE)
  poke.pbLearnMove(:ICEBURN)
  poke.pbLearnMove(:FREEZESHOCK)
  poke.pbLearnMove(:VICTORYDANCE)
  poke.item = :LVCVICCREST
  poke.ot = "Victory"
   poke.flickerID =
  {
    :interval => 3,
    :IDlist => [12345],
    :weight => 100,
    :timer => 0,
    :display => poke.publicID,
  }
  poke.flickerLocation = 
  {
    :interval => 2,
    :IDlist => lvc_make_flicker(["Purgatorium", "Deux Finalis", "Core Crown", "Edge of My World", "Gearen Shop", "Liberty Garden"], 50, chance: 40, use_all_chars: true),
    :weight => 100,
    :timer => 0,
    :display => poke.obtainText,
  }
  poke.flickerOT = 
  {
    :interval => 2,
    :OTList => lvc_make_flicker(["M14", "MysGift", "Victory"], 50, chance: 30, use_all_chars: true),
    :weight => 80,
    :timer => 0,
    :display => poke.ot,
  }
  poke.obtainMode = 4
  poke.obtainLevel = 50
  poke.makeShiny
  pbAddPokemon(poke)
  
  poke=PokeBattle_Pokemon.new(:JIRACHI,100,$Trainer,false)
  poke.pbLearnMove(:DOOMDESIRE)
  poke.pbLearnMove(:COSMICPOWER)
  poke.pbLearnMove(:PSYCHIC)
  poke.pbLearnMove(:WISH)
  poke.ot = "Lyra"
  poke.flickerID =
  {
    :interval => 3,
    :IDlist => [40122, 20043],
    :weight => 100,
    :timer => 0,
    :display => poke.publicID,
  }
  poke.flickerLocation = 
  {
    :interval => 2,
    :IDlist => lvc_make_flicker(["Purgatorium", "Deux Finalis", "Core Crown", "Xen Observatory", "Edge of My World", "Faraway place"], 50, chance: 40, use_all_chars: true),
    :weight => 100,
    :timer => 0,
    :display => poke.obtainText,
  }
  poke.flickerOT = 
  {
    :interval => 2,
    :OTList => lvc_make_flicker(["WISHMKR", "CHANNEL", "Lyra"], 50, chance: 30, use_all_chars: true),
    :weight => 80,
    :timer => 0,
    :display => poke.ot,
  }
  poke.obtainMode = 4
  poke.obtainLevel = 5
  poke.makeShiny
  poke.item = :LVCRACHICREST
  pbAddPokemon(poke)
end