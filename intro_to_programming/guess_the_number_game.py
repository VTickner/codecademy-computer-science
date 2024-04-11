import random

class Player:
    def __init__(self, name):
        self.name = name
        self.lives = 3
        self.game_stats = GameStats()

    def __repr__(self):
        return f"{self.name} has {self.lives} lives left!"

    def reduce_life(self):
        self.lives -= 1

    def add_win(self):
        self.game_stats.add_win()

    def add_loss(self):
        self.game_stats.add_loss()

class GameStats:
    def __init__(self):
        self.total_wins = 0
        self.total_losses = 0

    def __repr__(self):
        return f"Total Wins: {self.total_wins}, Total Losses: {self.total_losses}"

    def add_win(self):
        self.total_wins += 1

    def add_loss(self):
        self.total_losses += 1

class GuessTheNumber:
    def __init__(self):
        self.game_stats = GameStats()

    def __repr__(self):
        return "Welcome to guess the number game!"

    def play_game(self):
        print(game)
        player_name = input("Enter your name: ")
        player = Player(player_name)
        play_again = "y"
        while play_again.lower() == "y":
            player.lives = 3
            number_to_guess = random.randint(1, 20)
            print("Guess a number between 1 and 20...")
            while player.lives > 0:
                guess = int(input("Guess the number: "))
                if guess == number_to_guess:
                    print(f"Congratulations {player.name}! You guessed the correct number")
                    player.add_win()
                    break
                else:
                    if guess < number_to_guess:
                        print("Your guess was too low.")
                    else:
                        print("Your guess was too high.")
                    player.reduce_life()
                    print(player)
            if player.lives == 0:
                print(f"Game Over! You lose {player.name}")
                player.add_loss()
            print(player.game_stats)
            play_again = input(f"Do you want to play again {player.name} (y/n): ")
        print(f"Thanks for playing {player.name}!")

game = GuessTheNumber()
game.play_game()