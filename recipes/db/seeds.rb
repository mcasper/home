baking = Category.create!(name: "Baking")
breakfast = Category.create!(name: "Breakfast")
dinner = Category.create!(name: "Dinner")

Recipe.create!(name: "Cinamon Rolls", url: "https://www.tastesoflizzyt.com/homemade-cinnamon-rolls", category: baking)
Recipe.create!(name: "Holiday Rolls", url: "https://joyfoodsunshine.com/homemade-dinner-rolls/", category: dinner)
Recipe.create!(
  name: "Banana Bread",
  url: nil,
  category: baking,
  notes: "Beat together:\r\n  1 cup sugar\r\n  1/2 cup vegetable oil\r\n  2 eggs\r\n\r\nBeat together:\r\n  3 ripe bananas\r\n\r\nAdd 1 1/4 cup flour\r\n    1 tsp baking sode\r\n    1/2 tsp salt\r\nto bananas\r\n\r\nOil 2 large loaf pans and line bottom with wax paper; divide batter between 2 pans, sprinkle coating (heavy is good) of sugar on top.\r\n\r\nBake at 325 for 30 to 35 min with a sheet of foil over the pans to keep from browning too quickly. Remove foil and bake 5 to 10 min more until an inserted knife comes out clean.\r\n\r\nRemove from the the oven, run a knife around the edge of the pans to loosen loaves. Roll out onto large piece of foil and immediately wrap to seal in moisture (remove wax paper)\r\n\r\nI quadruple this and pour in various size pans - just fill them to about 1/2 to 2/3 full.\r\n"
)
