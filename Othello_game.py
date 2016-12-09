# This module contains functions of the Othello game logic

directions = {1: (-1, -1), 2: (-1, 0), 3: (-1, 1),
              8: (0, -1),              4: (0, 1),
              7: (1, -1),  6: (1, 0),  5: (1, 1)}
# directions are represented in digits 1-8, illustrated below
# 1 2 3
# 8 X 4
# 7 6 5


class IllegalMoveError(Exception):
    """
    illegal move, raises when the player chooses to drop:
    --outside the board
    --on another piece
    --on a position which the player have no opponent pieces to flip
    """
    pass


class GameOverError(Exception):
    """
    game over, raises when:
    --the game board is full
    --both sides have no legal moves
    """
    pass


def take_turn(board):
    """
    let the user to input move coordinates. if the move is legal or
    not, return the move tuple. if illegal, raise the IllegalMoveError
    :param board: object board
    :return: move tuple
    """
    while True:
        try:
            if check_board_full(board):
                raise GameOverError
            move_list = input().split()
            move = (int(move_list[0]) - 1,
                    int(move_list[1]) - 1)
            check_legal_move(board, move)
            return move
        except IllegalMoveError:
            print('INVALID')


def get_pieces_to_flip(board, move):
    """
    get a list of coordinates of opponent pieces to flip
    --if list = []: no pieces to flip, means that it's a illegal move

    :param board: class Board
    :param move: user move
    :return: list of coordinates of opponent pieces to flip
    """
    total_pieces_to_flip = []

    turn = board.turn
    if turn == 'white':
        opposite_turn = 'black'
    else:
        opposite_turn = 'white'

    for i in range(1, 9):
        adjacent = (move[0] + directions[i][0], move[1] + directions[i][1])
        if check_on_board(board, adjacent) and \
                opposite_turn == board.board[adjacent[0]][adjacent[1]]:
            # The outer loop finds all possible directions to have pieces
            # to flip by examining all eight adjacent spaces. Spaces with
            # the current player piece/outside the board are ignored

            total_pieces_to_flip += check_each_direction(
                    move, board, turn, opposite_turn, i)
    return total_pieces_to_flip


def check_each_direction(move, board, turn, opposite_turn, direction):
    """
    the inner loops of  'get_pieces_to_flip', check a single direction from
    the piece player tend to drop. The loop handles three situations:
    direction ends at empty space/opponent piece/current player piece

    :param move: move tuple
    :param board: game board object
    :param turn: current player turn
    :param opposite_turn: opposite player
    :param direction: the direction the function is checking, equals to the
                      iteration of the outer loop
    :return: a list containing all the pieces to flip in this single direciton
    """
    temp_pieces_to_flip = []

    for x in range(1000):
        check = (move[0] + directions[direction][0] * (x+1),
                 move[1] + directions[direction][1] * (x+1))
        # 'check' is the piece that goes on to the direction that
        # the loop is checking

        if check_on_board(board, check):
            if turn == board.board[check[0]][check[1]]:
                # piece belongs to the player, means that the iteration is over
                return temp_pieces_to_flip
            elif opposite_turn == board.board[check[0]][check[1]]:
                # piece belongs to the opponent
                temp_pieces_to_flip.append(check)
            else:
                # empty space
                return []
        else:
            return []


def check_board_full(board):
    """
    check if the board is full
    :param board: game board object
    :return: True if the board is full, vice versa
    """
    for r in board.board:
        for c in r:
            if c == '.':  # the board is not full
                return False
    return True


def check_board_no_legal_move(board):
    """
    check if there is no legal move for both players on the board

    :param board: game board object
    :return: False if there are still legal spaces, vice versa
    """
    for r in range(len(board.board)):
        for c in range(len(board.board[r])):
            if board.board[r][c] == '.':
                if len(get_pieces_to_flip(board, (r, c))) != 0:
                    # have at least one opponent piece to flip
                    return False
    return True


def check_legal_move(board, move):
    """
    check if the move is legal, if not, raise IllegalMoveError

    :param board: game board object
    :param move: move tuple
    """
    if not check_on_board(board, move) or \
        not check_empty_space(board, move) or \
            len(get_pieces_to_flip(board, move)) == 0:
        raise IllegalMoveError


def check_empty_space(board, move):
    """
    check if the move refers to an empty space on the board

    :param board: game board object
    :param move: move tuple
    :return: True if it is an empty space, vice versa
    """
    if board.board[move[0]][move[1]] == '.':
        return True
    else:
        return False


def check_on_board(board, move):
    """
    check if the move is on the board

    :param board: game board object
    :param move: move tuple
    :return: True if the move is on the board, vice versa
    """
    if 1 <= move[0] + 1 <= board.row_num and 1 <= move[1] + 1 <= board.col_num:
        return True
    else:
        return False


def most_and_least_pieces(board):
    """
    compare the number of pieces of the two sides on the board, and return
    a tuple containing the two sides

    :param board:
    :return: (side with the most pieces on the board, side with the least pieces)
    """
    if board.black_num > board.white_num:
        return 'black', 'white'
    elif board.black_num < board.white_num:
        return 'white', 'black'
