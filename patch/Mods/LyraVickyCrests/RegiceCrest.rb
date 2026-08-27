PBStuff::POKEMONTOCREST[:REGICE] = :LVCRICECREST


ModCacheInjection.hook(:items) {
  $cache.items[:LVCRICECREST] = ItemData.new(:LVCRICECREST, {
    name: "Regice Crest",
    desc: "Regice gains the Ghost typing and its Normal-type moves become Ghost-type. Special moves use Sp. Def.",
    price: 0,
    crest: true,
    noUseInBattle: true,
    noUse: true,
  })
}


