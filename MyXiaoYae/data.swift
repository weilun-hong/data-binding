//
struct shop {
    var name: String
    var foods: [String]
}

struct foodInfo {
    var name: String
    var cost: Int
}

let shops: [shop] = [
    shop(name: "永和豆漿", foods: ["小籠湯包", "蔥抓餅", "蘿蔔糕", "招牌乳酪蛋餅", "饅頭", "原味飯糰", "燒餅", "油條", "蛋餅", "豆漿"]),
    shop(name: "吮指王", foods: ["特大雞排", "脆皮大雞排", "脆皮檸檬雞排", "檸檬大雞排", "泰式大雞排", "蜜汁叉燒雞排", "甘梅地瓜", "甜不辣", "薯條", "滷香豆干", "四季豆", "雞翅", "無骨鹽酥雞"])
]

struct order {
    let id: Int
    let shop: String
    let food: String
    let count: Int
}

