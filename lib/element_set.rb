module ElementSet

  class Medium
    def self.set
     [['original', 'painting'],
     ['original', 'drawing'],
     ['original', 'production', 'drawing'],
     ['original', 'production', 'sericel'],
     ['original', 'mixed-media'],
     ['one-of-a-kind', 'mixed-media'],
     ['embellished', 'one-of-a-kind', 'mixed-media'],
     ['single-edition', 'one-of-a-kind', 'mixed-media'],
     ['embellished', 'single-edition', 'one-of-a-kind', 'mixed-media'],
     ['one-of-a-kind', 'hand-pulled', 'print'],
     ['embellished', 'one-of-a-kind', 'hand-pulled', 'print'],
     ['single-edition', 'one-of-a-kind', 'hand-pulled', 'print'],
     ['embellished', 'single-edition', 'one-of-a-kind', 'hand-pulled', 'print'],
     ['print'],
     ['embellished', 'print'],
     ['single-edition', 'print'],
     ['hand-pulled', 'print'],
     ['open-edition', 'print'],
     ['photography'],
     ['limited-edition', 'print'],
     ['embellished', 'limited-edition', 'print'],
     ['limited-edition', 'hand-pulled', 'print'],
     ['single-edition', 'hand-pulled', 'print'],
     ['limited-edition', 'photography'],
     ['animation', 'sericel'],
     ['limited-edition', 'sericel'],
     ['hand-blown', 'sculpture-type'],
     ['hand-made', 'sculpture-type'],
     ['sculpture', 'sculpture-type'],
     ['embellished', 'sculpture', 'sculpture-type'],
     ['limited-edition', 'sculpture', 'sculpture-type'],
     ['embellished', 'limited-edition', 'sculpture', 'sculpture-type']]
    end
  end
end