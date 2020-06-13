class Dog
  attr_accessor :name, :breed, :id
  
  def initialize(hash)
    @name = hash[:name]
    @breed = hash[:breed]
    @id = hash[:id]
  end
  
  def self.create_table
    sql = <<-SQL
      CREATE TABLE dogs (
      id INTEGER PRIMARY KEY,
      name TEXT, 
      breed TEXT);
    SQL
    
     DB[:conn].execute(sql)
  end
  
  def self.drop_table
    sql = <<-SQL
      DROP TABLE dogs;
    SQL
    
    DB[:conn].execute(sql)
  end
  
  def update
    sql = <<-SQL
    UPDATE dogs SET
    name = ?, 
    breed = ? 
    WHERE id = ?
    SQL
    
    DB[:conn].execute(sql, self.name, self.breed, self.id)
  end
  
  def save
    if self.id != nil
      self.update
    else
      sql = "INSERT INTO dogs (name, breed) VALUES (?, ?)"
   
      DB[:conn].execute(sql, self.name, self.breed)
   
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
    end
    return self
  end
  
  def self.create(name:, breed:)
    dog = Dog.new(name: name, breed: breed)
    dog.save
    dog
  end
  
  def self.new_from_db(array)
    id, name, breed  = array[0], array[1], array[2]
    self.new(id: id, name: name, breed: breed)
  end
  
  def self.find_by_id
    sql = "SELECT * FROM dogs WHERE id = ? LIMIT 1"
    return DB[:conn].execute(sql, self.id)
  end
  
  def self.find_by_name(name)
    sql = "SELECT * FROM dogs WHERE name = ? LIMIT 1"
    DB[:conn].execute(sql, name)
  end
end