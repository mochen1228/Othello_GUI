# This is the FULL version of the Othello game

import Othello_game_old  # Game logic core module


class Board:
    """
    Board object
    """
    def __init__(self):
        self.turn = '.'     # turn name
        self.white_num = 0  # number of white pieces
        self.black_num = 0  # number of black pieces
        self.row_num = 0    # number of rows
        self.col_num = 0    # number of columns
        self.board = []     # the game board
        self.create_new_board()

    def create_new_board(self):
        """
        Let the user choose the size of the game board and create a
        new one
        """
        self.row_num = int(input())
        self.col_num = int(input())
        new_board = []
        for r in range(self.row_num):
            column = []
            for c in range(self.col_num):
                column.append(self.turn)
            new_board.append(column)
        self.board = new_board

    def count_pieces(self):
        """
        Count the number of pieces of each color on the game board
        """
        (self.black_num, self.white_num) = (0, 0)
        # Set both counter to zero

        for r in self.board:
            for c in r:
                if c == 'W':
                    self.white_num += 1
                if c == 'B':
                    self.black_num += 1

    def drop_piece(self, coordinate: tuple):
        """
        register a user piece on the game board list
        :param coordinate: coordinate tuple
        """
        self.board[coordinate[0]][coordinate[1]] = self.turn

    def switch_turn(self):
        """
        switch the turn to the opposite one
        """
        if self.turn == 'B':
            self.turn = 'W'
        elif self.turn == 'W':
            self.turn = 'B'

    def flip_pieces(self, flip_list):
        """
        go through the given list of coordinate, 'flip' them to the opposite
        user piece
        :param flip_list: list of coordinate
        """
        for space in flip_list:
            self.board[space[0]][space[1]] = self.turn


class Display:
    """
    This class serves to display data to the console
    """
    def __init__(self, board):
        self.board = board  # game board object

    def display(self):
        self.show_pieces()
        self.show_board()

    def show_pieces(self):
        """
        print the count of pieces of each side
        """
        self.board.count_pieces()
        print("B: {} W: {}".format(self.board.black_num,
                                   self.board.white_num))

    def show_board(self):
        """
        Print out the game board
        """
        for r in self.board.board:
            for i in range(len(r)):
                if i == len(r) - 1:
                    print(r[i])
                else:
                    print(r[i], end=' ')

    def show_turn(self):
        """
        print out the turn of the nect move
        """
        print('TURN: ' + self.board.turn)


class Game:
    """
    This class is for the main game process
    """
    def __init__(self):
        self.more_or_less = None  # determine the winning condition
        self.current_move = None  # current move coordinates
        self.board = Board()
        self.display = Display(self.board)
        self.set_first_turn()
        self.set_initial_pieces()
        self.set_more_or_less()

    def set_first_turn(self):
        """
        take the user input and set which player to play first
        """
        first_turn = input()  # input should be 'B' or 'W'
        self.board.turn = first_turn

    def set_initial_pieces(self):
        """
        take the user input adn set the initial pieces on the game board
        the top-left piece should be the user inputted piece
        """
        top_left = input()  # input should be 'B' or 'W'
        tl_coordinate = (int(self.board.row_num/2 - 1),
                         int(self.board.col_num/2) - 1)
        # create the coordinate for the top-left piece

        self.board.board[tl_coordinate[0]][tl_coordinate[1]] = top_left
        self.board.board[tl_coordinate[0] + 1][tl_coordinate[1] + 1] = top_left
        # set the two diagonal pieces as the user input piece

        if top_left == 'B':
            top_left = 'W'
        else:
            top_left = 'B'
        # switch the piece to opposite in order to set the remaining two pieces

        self.board.board[tl_coordinate[0] + 1][tl_coordinate[1]] = top_left
        self.board.board[tl_coordinate[0]][tl_coordinate[1] + 1] = top_left
        # set the rest of the two pieces as the opposite piece

    def set_more_or_less(self):
        """
        set the user input and set how to determine the win
        '>' means that the user who have the most pieces wins
        '<' vice versa
        """
        self.more_or_less = input()  # input should be '>' or '<'

    def take_turn(self):
        """
        main function of taking turn
        """
        self.current_move = Othello_game_old.take_turn(self.board)
        print('VALID')
        self.board.drop_piece(self.current_move)
        self.board.flip_pieces(Othello_game_old.get_pieces_to_flip
                               (self.board, self.current_move))
        print(self.board.board)
        self.board.switch_turn()
        self.display.display()

        if Othello_game_old.check_board_no_legal_move(self.board):
            # switch the turn back to the previous player if there are no
            # legal places for the current player to move
            self.board.switch_turn()
            if Othello_game_old.check_board_no_legal_move(self.board):
                raise Othello_game_old.GameOverError

        self.display.show_turn()
        # This part is separated to avoid printing the next turn after the game
        # is already over

    def game_process(self):
        """
        the main game process
        """
        self.display.display()
        self.display.show_turn()
        while True:
            try:
                self.take_turn()
            except Othello_game_old.GameOverError:
                self.game_over()
                break

    def game_over(self):
        """
        determine different winning conditions and print out the name of
        the winner, print None if there is no winner (draw)
        """
        if self.board.black_num == self.board.white_num:
            print('WINNER: NONE')
        elif self.more_or_less == '>':
            print('WINNER: ' +
                  Othello_game_old.most_and_least_pieces(self.board)[0])
        else:
            print('WINNER: ' +
                  Othello_game_old.most_and_least_pieces(self.board)[1])

if __name__ == '__main__':
    print('FULL')
    game = Game()
    game.game_process()
