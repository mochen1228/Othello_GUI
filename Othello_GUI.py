# This module is the main loop module
import Othello_Dataentry
import tkinter
import tkinter.messagebox


def exit_game():
    if tkinter.messagebox.askokcancel('Quit?', 'Do you wanna quit the game?'):
        root.destroy()

if __name__ == '__main__':
    print('Othello GUI version 1.1\n'
          'Data recorder launched')
    root = tkinter.Tk()
    root.protocol('WM_DELETE_WINDOW', exit_game)
    Othello_Dataentry.DataEntry(root)
    root.mainloop()
