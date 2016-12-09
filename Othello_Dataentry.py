# This module is the game data entry window module
import tkinter
from tkinter import N, E, S, W
import tkinter.messagebox
import Othello_Gamewindow


class DataEntry:
    """
    This is the TOP level of the program
    frame 1: the labels for the option menus
    frame 2: the option menus
    frame 3: the more or less label and the pair of radio button
    frame 4: the start and info button
    """
    def __init__(self, master):
        self.master = master  # root mainloop

        self.frame_1 = tkinter.Frame(self.master)
        self.frame_2 = tkinter.Frame(self.master, padx=20)
        self.frame_3 = tkinter.Frame(self.master)
        self.frame_4 = tkinter.Frame(self.master)

        self.Frame_1 = Frame1(self.frame_1)
        self.Frame_2 = Frame2(self.frame_2)
        self.Frame_3 = Frame3(self.frame_3)
        self.Frame_4 = Frame4(self.frame_4, self)

        self.row = None
        self.col = None
        self.first = None
        self.top_left = None
        self.condition = None

        self.create_frames()
        self.new_window = None  # main game window, tkinter.toplevel object
        self.data_list = None  # list of data inputted

    def create_frames(self):
        """
        create frames for the data entry window
        """
        self.frame_1.grid(row=0, column=0, sticky=N+S)
        self.frame_2.grid(row=0, column=1)
        self.frame_3.grid(row=1, column=0, columnspan=2)
        self.frame_4.grid(row=2, column=0, columnspan=2)

        self.row = self.Frame_2.str_var_row
        self.col = self.Frame_2.str_var_col
        self.first = self.Frame_2.str_var_first
        self.top_left = self.Frame_2.str_var_topleft
        self.condition = self.Frame_3.int_var


class Frame1:
    """
    Label Frame
    """
    def __init__(self, master):
        self.master = master
        self.create_label()

    def create_label(self):
        """
        create labels in the window
        """
        row_num_label = tkinter.Label(self.master, text='rows :',
                                      width=10, height=1, pady=8)
        col_num_label = tkinter.Label(self.master, text='columns :',
                                      width=10, height=1, pady=5)
        first_turn_label = tkinter.Label(self.master, text='first turn :',
                                         width=10, height=1, pady=6)
        topleft_label = tkinter.Label(self.master, text='top left :',
                                      width=10, height=1, pady=6)

        row_num_label.grid(row=0, column=0)
        col_num_label.grid(row=1, column=0)
        first_turn_label.grid(row=2, column=0)
        topleft_label.grid(row=3, column=0)


class Frame2:
    """
    Option menu Frame
    """
    def __init__(self, master):
        self.master = master

        self.row_option = None  # entry widget of row number
        self.col_option = None  # ...column number
        self.first_option = None  # ...first player to go
        self.tl_option = None  # ...top left piece player

        self.str_var_row = tkinter.StringVar()  # variable for row number menu
        self.str_var_col = tkinter.StringVar()
        self.str_var_first = tkinter.StringVar()
        self.str_var_topleft = tkinter.StringVar()

        self.size_option_list = ('2', '4', '6', '8',
                                 '10', '12', '14', '16'
                                 )
        # a tuple of options containing size choice

        self.side_option_list = ('black', 'white'
                                 )
        # a tuple of options containing 'black' and 'white'

        self.create_option_menu()

    def create_option_menu(self):
        """
        create tex boxes in the window
        """
        self.row_option = tkinter.OptionMenu(self.master, self.str_var_row,
                                             *self.size_option_list)
        self.col_option = tkinter.OptionMenu(self.master, self.str_var_col,
                                             *self.size_option_list)
        self.first_option = tkinter.OptionMenu(self.master, self.str_var_first,
                                               *self.side_option_list)
        self.tl_option = tkinter.OptionMenu(self.master, self.str_var_topleft,
                                            *self.side_option_list)

        self.str_var_row.set(self.size_option_list[3])
        self.str_var_col.set(self.size_option_list[3])
        self.str_var_first.set(self.side_option_list[0])
        self.str_var_topleft.set(self.side_option_list[1])

        self.row_option.grid(row=0, column=0, sticky=E+W)
        self.col_option.grid(row=1, column=0, sticky=E+W)
        self.first_option.grid(row=2, column=0, sticky=E+W)
        self.tl_option.grid(row=3, column=0, sticky=E+W)


class Frame3:
    """
    Radio Button Frame
    """
    def __init__(self, master):
        self.master = master
        self.radio_more = None  # radiobutton widget for more
        self.radio_less = None  # ...less

        self.int_var = tkinter.IntVar()  # variable for the two related radiobutton
        self.create_radiobutton()

    def create_radiobutton(self):
        """
        create radio buttons in the window
        """
        self.radio_more = tkinter.Radiobutton(self.master, text='more',
                                              variable=self.int_var,
                                              value=1)
        self.radio_less = tkinter.Radiobutton(self.master, text='less',
                                              variable=self.int_var,
                                              value=0)

        self.radio_more.grid(row=1, column=0)
        self.radio_less.grid(row=1, column=1)

        self.int_var.set(1)

        more_less_instruction = tkinter.Label(self.master,
                                              text='select winning condition')
        more_less_instruction.grid(row=0, columnspan=2)


class Frame4:
    """
    the Frame containing the two buttons on the bottom
    """
    def __init__(self, master, entry):
        self.master = master
        self.entry = entry
        self.create_buttons()
        self.info_popup = None  # the pop up window for game info
        self.data_list = None  # the data list pass on to the game window

    def create_buttons(self):
        """
        create the button that launches the main game window
        """
        start_button = tkinter.Button(self.master,
                                      text='start FULL game',
                                      command=self.create_game_window)
        start_button.grid(row=0, column=0, sticky=E+W)

        instructions_button = tkinter.Button(self.master,
                                             text='     info     ',
                                             command=self.instruction_popup)
        instructions_button.grid(row=0, column=1)

    def instruction_popup(self):
        """
        pop up a message box for instructions
        unfortunately I'm too lazy to write the instructions
        """
        self.info_popup = tkinter.messagebox.showinfo('Instructions',
                                                      message=
                                                      'Go Google it by yourself,'
                                                      ' LOLOLOL LMAO')

    def create_game_window(self):
        """
        launches the game game window
        data_list: contains multiple entry data and the radiobutton data
                   [row, col, first, top_left, condition]
        """
        self.data_list = [int(self.entry.row.get()),
                          int(self.entry.col.get()),
                          str(self.entry.first.get()),
                          str(self.entry.top_left.get()),
                          self.entry.condition.get()]

        Othello_Gamewindow.GameWindow(self.master.master, self.data_list)
        # the game window launched, mainloop will be withdrawn

        print('Game started'
              '\nrow number:', self.data_list[0],
              '\ncol number:', self.data_list[1],
              '\nfirst turn:', self.data_list[2],
              '\ntop left piece:', self.data_list[3]
              )
