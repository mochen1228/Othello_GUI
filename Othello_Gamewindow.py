# This module is the game window module
import tkinter
import tkinter.font
import Othello_game
from tkinter import W, E, S, N
import tkinter.messagebox


class GameWindow:
    """
    The game window class, displays the board and the game data bar
    """
    def __init__(self, master, data):
        self.master = master
        self.game_window = tkinter.Toplevel(master)  # the game window
        self.game_process = GameProcess(data)  # the game process that stores data
        self.game_window.protocol('WM_DELETE_WINDOW', self.exit_window)

        self.frame_1 = tkinter.Frame(self.game_window)  # the frame widget
        self.frame_2 = tkinter.Frame(self.game_window)

        self.game_data = data  # data received from data entry

        self.game_window.rowconfigure(0, weight=1)
        self.game_window.columnconfigure(0, weight=1)

        # the two bellow are frame objects, their masters are tkinter.Frame
        # they serves to store, modify and display data.
        self.Frame_1 = Frame1(self.frame_1, self.game_process)  # board
        self.Frame_2 = Frame2(self.frame_2, self.game_data,
                              self.game_process)  # data display

        self.Frame_2.gameboard.bind('<Button-1>', self.take_turn)  # when mouse click the board

        self.frame_1.grid(row=1, column=0, sticky=W+E)
        self.frame_2.grid(row=0, column=0, sticky=W+E+S+N)

        self.Frame_2.game_process.board.count_pieces()
        self.Frame_1.update_board_display()  # display the game data at the start

        self.master.withdraw()  # Don't forget to close the mainloop

    def take_turn(self, event):
        """
        the main function of user taking turn
        :param event: mouse click
        """
        try:
            self.Frame_2.make_move(event)
            self.Frame_1.update_board_display()
        except Othello_game.IllegalMoveError:
            print('INVALID')
            self.Frame_2.current_mouse_move = None
            self.Frame_2.current_move_list = []
        except Othello_game.GameOverError:
            final_black = self.Frame_2.game_process.board.black_num
            final_white = self.Frame_2.game_process.board.white_num
            self.Frame_2.game_process.board.count_pieces()
            self.Frame_1.update_board_display()
            if final_black == final_white:
                tkinter.messagebox.showinfo(message=
                                            "Game Over\nIt's a draw"
                                            "\nPlease exit the game window")
            elif self.Frame_2.game_process.more_or_less == 1:
                tkinter.messagebox.showinfo(
                        message="Game Over\nWinner is " +
                                Othello_game.most_and_least_pieces(
                                    self.game_process.board
                                )[0] + "\nPlease exit the game window")
            else:
                tkinter.messagebox.showinfo(
                        message="Game Over\nWinner is " +
                                Othello_game.most_and_least_pieces(
                                    self.game_process.board
                                )[1] + "\nPlease exit the game window")

    def exit_window(self):
        self.master.deiconify()
        self.game_window.destroy()


class Frame1:
    """
    contains piece count and turn indicator
    """
    def __init__(self, master, process):
        self.master = master  # tkinter.Frame
        self.process = process  # GameProcess
        self.font = tkinter.font.Font(size=12)

        self.black_piece_label = None
        self.white_piece_label = None
        self.turn_name_label = None
        self.create_label()

    def create_label(self):
        """
        create labels for the frame
        """
        self.master.columnconfigure(0, weight=1)
        self.master.columnconfigure(1, weight=1)
        self.master.columnconfigure(2, weight=1)

        self.black_piece_label = tkinter.Label(self.master, text='BLACK: ',
                                               height=1,
                                               font=self.font)
        self.white_piece_label = tkinter.Label(self.master, text='WHITE: ',
                                               height=1,
                                               font=self.font)
        self.turn_name_label = tkinter.Label(self.master, text='TURN: ',
                                             height=1,
                                             font=self.font)

        self.black_piece_label.grid(row=0, column=0, sticky=W)
        self.white_piece_label.grid(row=0, column=2, sticky=E)
        self.turn_name_label.grid(row=0, column=1)

    def update_board_display(self):
        """
        update the pieces count and turn data stored in the class
        object and display them
        """
        self.black_piece_label.config(text='BLACK: ' +
                                      str(self.process.board.black_num))
        self.white_piece_label.config(text='WHITE: ' +
                                      str(self.process.board.white_num))
        self.turn_name_label.config(text='TURN: ' +
                                    self.process.board.turn)


class Frame2:
    """
    game board frame, stores and handles all data related to displaying
    and modifying the board
    """
    def __init__(self, master, data, process):
        self.master = master
        self.gameboard = None  # board canvas
        self.game_process = process

        self.square_size = 65  # initial square size
        self.circle_rad = self.square_size / 2 - 25  # initial circle rad is actually 20

        self.row_num = data[0]
        self.col_num = data[1]
        self.board_width = data[1] * self.square_size  # initial board size
        self.board_height = data[0] * self.square_size

        self.width_ratio = 1  # ratio of the current width to the initial size
        self.height_ratio = 1

        self.coordinates = []  # initial coordinates for the rectangles drawn on the board

        self.current_mose_click = None  # pixel coordinate of current mouse click
        self.current_mouse_move = None  # single move tuple of the mouse
        self.current_move_list = []  # a list containing only one move tuple (user move)
        # purpose of this list: the drop piece function only accepts list, this is
        # to avoid creating a similar function that accepts a single move tuple

        self.create_gameboard()

        self.gameboard.addtag_all('all')

        self.draw_board()
        self.set_initial_pieces()

    def create_gameboard(self):
        """
        create the gameboard canvas
        """
        self.gameboard = ResizableCanvas(self.master, width=self.board_width,
                                         height=self.board_height,
                                         bg='green', highlightthickness=0)
        self.gameboard.pack(fill=tkinter.BOTH, expand=tkinter.YES)

    def get_board_list(self):
        """
        get a list of coordinates for rectangles to draw on the board
        """
        for r in range(self.row_num):
            row_list = []
            for c in range(self.col_num):
                row_list.append([c * self.square_size, r * self.square_size,
                                 (c + 1) * self.square_size, (r + 1) * self.square_size])
            self.coordinates.append(row_list)

    def draw_board(self):
        """
        draw the initial, empty board
        """
        self.get_board_list()
        for r in self.coordinates:
            for c in r:
                self.gameboard.create_rectangle(c[0], c[1], c[2], c[3])

    def calculate_ratio(self):
        """
        calculate the ratio of the CURRENT size to the INITIAL size
        """
        current_height = self.gameboard.winfo_height()
        current_width = self.gameboard.winfo_width()
        self.height_ratio = current_height / self.board_height
        self.width_ratio = current_width / self.board_width

    def make_move(self, event):
        """
        when mouse click, draw a piece on the corresponding grid,
        flip opponent pieces if available
        :param event: mose click
        """
        self.current_mose_click = (event.x, event.y)
        self.get_piece_coor()
        Othello_game.check_legal_move(self.game_process.board,
                                      self.current_mouse_move)
        print('Move registered', self.current_mouse_move)  # show valid move on console
        self.drop_piece(self.current_move_list,
                        self.game_process.board.turn)

        flip_list = Othello_game.get_pieces_to_flip(self.game_process.board,
                                                    self.current_mouse_move)

        self.drop_piece(flip_list, self.game_process.board.turn)

        self.game_process.take_turn(self.current_move_list[0])
        self.game_process.board.count_pieces()
        self.current_move_list = []  # set the current move list to empty

    def drop_piece(self, move_list, turn):
        """
        given a list of moves, draw all of them on the board
        :param move_list: list of moves(coordinates)
        """
        for move in move_list:
            print(move)
            self.gameboard.create_oval(move[1] * self.square_size * self.width_ratio +
                                       self.circle_rad * self.width_ratio,
                                       move[0] * self.square_size * self.height_ratio +
                                       self.circle_rad * self.height_ratio,
                                       (move[1] + 1) * self.square_size * self.width_ratio -
                                       self.circle_rad * self.width_ratio,
                                       (move[0] + 1) * self.square_size * self.height_ratio -
                                       self.circle_rad * self.height_ratio,
                                       fill=turn)  # the turn should be lower case color word

    def get_piece_coor(self):
        """
        get the BOARD coordinate of the current mouse click
        """
        self.calculate_ratio()
        x = int(self.current_mose_click[0] / (self.square_size * self.width_ratio))
        y = int(self.current_mose_click[1] / (self.square_size * self.height_ratio))
        self.current_move_list.append((y, x))
        self.current_mouse_move = (y, x)
        print(self.current_mouse_move)

    def set_initial_pieces(self):
        """
        set the four initial piece on the board
        """
        top_left = self.game_process.init_data[3]

        top_left_list = [(self.row_num/2 - 1, self.col_num/2 - 1),
                         (self.row_num/2, self.col_num/2)]
        print(top_left_list)
        top_right_list = [(self.row_num/2 - 1, self.col_num/2),
                          (self.row_num/2, self.col_num/2 - 1)]
        print(top_right_list)
        # lists of two diagonal direction of initial pieces

        self.drop_piece(top_left_list, top_left)  # draw \ diagonal

        if top_left == 'black':
            top_left = 'white'
        else:
            top_left = 'black'

        self.drop_piece(top_right_list, top_left)  # draw / diagonal


class GameProcess:
    """
    main game process, only process the board inner data
    """
    def __init__(self, data):
        self.init_data = data  # initial data received from data entry
        self.more_or_less = None  # determine the winning condition
        self.current_move = None  # current move coordinates

        self.board = BoardData(self.init_data)

        self.set_first_turn()
        self.set_initial_pieces()
        self.set_more_or_less()

    def set_first_turn(self):
        """
        set the first turn data from the initial data list
        """
        first_turn = self.init_data[2]
        self.board.turn = first_turn

    def set_initial_pieces(self):
        """
        set the initial pieces on the game board according to the initial
        data list
        """
        top_left = self.init_data[3]
        tl_coordinate = (int(self.board.row_num/2 - 1),  # tl = top left
                         int(self.board.col_num/2) - 1)
        # create the coordinate for the top-left piece

        self.board.board[tl_coordinate[0]][tl_coordinate[1]] = top_left
        self.board.board[tl_coordinate[0] + 1][tl_coordinate[1] + 1] = top_left
        # set the two diagonal pieces as the user input piece

        if top_left == 'black':
            top_left = 'white'
        else:
            top_left = 'black'
        # tl right here should actually be top right

        self.board.board[tl_coordinate[0] + 1][tl_coordinate[1]] = top_left
        self.board.board[tl_coordinate[0]][tl_coordinate[1] + 1] = top_left
        # set the rest of the two pieces as the opposite piece

    def set_more_or_less(self):
        """
        set the winning condition according the the initial data list
        1 means that the user who have the most pieces wins
        0 less pieces
        """
        self.more_or_less = self.init_data[4]  # data should be 0 or 1

    def take_turn(self, move):
        """
        main function of taking turn
        :param move: current user move tuple
        """
        self.current_move = move
        print(self.current_move)

        self.board.drop_piece(self.current_move)
        self.board.flip_pieces(Othello_game.get_pieces_to_flip
                               (self.board, self.current_move))
        self.board.switch_turn()
        print(self.board.board)

        if Othello_game.check_board_no_legal_move(self.board):
            # switch the turn back to the previous player if there are no
            # legal places for the current player to move
            self.board.switch_turn()
            if Othello_game.check_board_no_legal_move(self.board):
                raise Othello_game.GameOverError


class BoardData:
    """
    containing board data
    """
    def __init__(self, data):
        self.init_data = data
        self.turn = '.'     # turn name, it should be 'black'/'white' after the game starts
        self.white_num = 0  # number of white pieces
        self.black_num = 0  # number of black pieces
        self.row_num = 0    # number of rows
        self.col_num = 0    # number of columns

        self.board = []
        # on the board list:
        # '.' represents an empty space
        # 'black' represents a black piece
        # 'white' represents a white piece

        self.create_new_board()

    def create_new_board(self):
        """
        create the two dimensional list according to the row & col data
        in the initial data list
        """
        self.row_num = self.init_data[0]
        self.col_num = self.init_data[1]
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
                if c == 'white':
                    self.white_num += 1
                if c == 'black':
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
        if self.turn == 'black':
            self.turn = 'white'
        elif self.turn == 'white':
            self.turn = 'black'

    def flip_pieces(self, flip_list):
        """
        go through the given list of coordinate, 'flip' them to the opposite
        user piece
        :param flip_list: list of coordinate
        """
        for coor in flip_list:
            self.board[coor[0]][coor[1]] = self.turn


class ResizableCanvas(tkinter.Canvas):
    """
    the canvas that can resize, have all the attributes of a normal canvaas class
    """
    def __init__(self, other, **kwargs):
        tkinter.Canvas.__init__(self, other, **kwargs)
        self.bind('<Configure>', self.resize)
        self.width = self.winfo_reqwidth()
        self.height = self.winfo_reqheight()

    def resize(self, event):
        width_scale = event.width/self.width
        height_scale = event.height/self.height
        self.width = event.width
        self.height = event.height
        self.config(height=self.height, width=self.width)
        self.scale("all", 0, 0, width_scale, height_scale)
