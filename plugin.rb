require 'bundler/setup'
require 'sequel'

class Plugin
  attr_accessor :id, :name, :code

  def initialize(id:, name:, code:)
    @id = id
    @name = name
    @code = code
  end

  def self.db
    @db ||= Sequel.connect('sqlite://plugins.db')
  end

  def self.create(name, code)
    id = db[:plugins].insert(name: name, code: code)
    new(id: id, name: name, code: code)
  end

  def self.find(id)
    row = db[:plugins].where(id: id).first
    new(id: row[:id], name: row[:name], code: row[:code]) if row
  end

  def save
    self.class.db[:plugins].where(id: id).update(name: name, code: code)
  end

  def update(name, code)
    self.class.db[:plugins].where(id: id).update(name: name, code: code)
    @name = name
    @code = code
  end

  def destroy
    self.class.db[:plugins].where(id: id).delete
  end

  def self.all
    db[:plugins].all.map do |row|
      new(id: row[:id], name: row[:name], code: row[:code])
    end
  end

  def to_json(options = {})
    {
      id: id,
      name: name,
      code: code
    }.to_json(options)
  end
end
