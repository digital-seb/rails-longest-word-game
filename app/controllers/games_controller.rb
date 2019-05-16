require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = []
    10.times do | letter |
      @letters << ('A'..'Z').to_a.sample
    end
  end

  def score
    @word = params[:word]
    response = open("https://wagon-dictionary.herokuapp.com/#{@word}")
    json = JSON.parse(response.read)
    json['found']
    @letters = params[:letters]
    if included?(@word.upcase, @letters) && json['found']
      @message = "The word is valid according to the grid and is an English word"
    elsif included?(@word, @letters)
      @message = "The word is valid according to the grid, but is not a valid English word"
    else
      @message = "The word can't be built out of the original grid"
    end
  end

  def included?(guess, grid)
    guess.chars.all? { |letter| guess.count(letter) <= grid.count(letter) }
  end
end
