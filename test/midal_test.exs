defmodule MidalTest do
  use ExUnit.Case
  doctest Midal

  test "handles basic microdata" do
    html = """
    <html>
      <body>
        <div itemscope>
          <div itemprop=\"name\">Midal</div>
        </div>
      </body>
    </html>
    """

    assert Midal.parse(html) == [%{"name" => "Midal"}]
  end

  test "parses multiple scopes in single document" do
    html = """
    <html>
      <body>
        <div itemscope>
          <div itemprop=\"language\">Elixir</div>
          <div itemprop=\"name\">Midal</div>
        </div>
        <div itemscope>
          <div itemprop=\"language\">Ruby</div>
          <div itemprop=\"name\">Mida</div>
        </div>
      </body>
    </html>
    """

    assert Midal.parse(html) == [
             %{"name" => "Midal", "language" => "Elixir"},
             %{"language" => "Ruby", "name" => "Mida"}
           ]
  end

  test "parses example from schema.org/Recipe" do
    with {:ok, file} = File.open("test/recipe.html"),
         html = IO.read(file, :all),
         :ok = File.close(file) do

          # TODO: replace with a more meaningful test - its just copying output...
          # it was verified by hand but still
           assert Midal.parse(html) == [
            %{
              "author" => "John Smith",
              "cookTime" => "PT1H",
              "datePublished" => "2009-05-08",
              "description" => "This classic banana bread recipe comes from my mom -- the walnuts add a nice texture and flavor to the banana bread.",
              "image" => "bananabread.jpg",
              "interactionStatistic" => %{
                "interactionType" => "http://schema.org/CommentAction",
                "userInteractionCount" => "140"
              },
              "name" => "Mom's World Famous Banana Bread",
              "nutrition" => %{
                "calories" => "240 calories",
                "fatContent" => "9 grams fat"
              },
              "prepTime" => "PT15M",
              "recipeIngredient" => ["3/4 cup of sugar", "1 egg",
               "3 or 4 ripe bananas, smashed"],
              "recipeInstructions" => "Preheat the oven to 350 degrees. Mix in the ingredients in a bowl. Add the flour last. Pour the mixture into a loaf pan and bake for one hour.",
              "recipeYield" => "1 loaf",
              "suitableForDiet" => "http://schema.org/LowFatDiet"
            }
          ]
         end
  end
end
