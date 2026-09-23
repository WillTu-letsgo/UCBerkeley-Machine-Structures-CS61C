#include "game.h"

#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "snake_utils.h"

/* Helper function definitions */
static void set_board_at(game_t *game, unsigned int row, unsigned int col, char ch);
static bool is_tail(char c);
static bool is_head(char c);
static bool is_snake(char c);
static char body_to_tail(char c);
static char head_to_body(char c);
static unsigned int get_next_row(unsigned int cur_row, char c);
static unsigned int get_next_col(unsigned int cur_col, char c);
static void find_head(game_t *game, unsigned int snum);
static char next_square(game_t *game, unsigned int snum);
static void update_tail(game_t *game, unsigned int snum);
static void update_head(game_t *game, unsigned int snum);

/* Task 1 */
game_t *create_default_game() {
  // TODO: Implement this function.
  game_t *game = malloc(sizeof(game_t));

  game->num_rows = 18;
  game->num_snakes = 1;

  game->board = malloc(game->num_rows * sizeof(char*));
  for(int i =0; i < game->num_rows; i++) {
    game->board[i] = malloc(22 * sizeof(char));
    if(i == 0 || i == 17) {
        strcpy(game->board[i],"####################\n");
    } else {
        strcpy(game->board[i],"#                  #\n");
    }
  }
  game->board[2][2] = 'd';
  game->board[2][3] = '>';
  game->board[2][4] = 'D';
  game->board[2][9] = '*';
  game->snakes = malloc(sizeof(snake_t));
  game->snakes[0].head_col = 4;
  game->snakes[0].head_row = 2;
  game->snakes[0].tail_col = 2;
  game->snakes[0].tail_row = 2;
  game->snakes[0].live = true;

  return game;
}

/* Task 2 */
void free_game(game_t *game) {
  // TODO: Implement this function.
  free(game->snakes);
  for(int i = 0; i < game->num_rows; i++){
    free(game->board[i]);
  }
  free(game->board);
  free(game);
  return;
}

/* Task 3 */
void print_board(game_t *game, FILE *fp) {
  // TODO: Implement this function.
  for(int i = 0; i < game->num_rows; i++){
    for(int j = 0; j < strlen(game->board[i]); j++){
        fprintf(fp,"%c",game->board[i][j]);
    }
  }
  return;
}

/*
  Saves the current game into filename. Does not modify the game object.
  (already implemented for you).
*/
void save_board(game_t *game, char *filename) {
  FILE *f = fopen(filename, "w");
  print_board(game, f);
  fclose(f);
}

/* Task 4.1 */

/*
  Helper function to get a character from the board
  (already implemented for you).
*/
char get_board_at(game_t *game, unsigned int row, unsigned int col) { return game->board[row][col]; }

/*
  Helper function to set a character on the board
  (already implemented for you).
*/
static void set_board_at(game_t *game, unsigned int row, unsigned int col, char ch) {
  game->board[row][col] = ch;
}

/*
  Returns true if c is part of the snake's tail.
  The snake consists of these characters: "wasd"
  Returns false otherwise.
*/
static bool is_tail(char c) {
  // TODO: Implement this function.
  if(c == 'w'||c == 'a'||c == 's'||c == 'd'){
    return true;
  }
  return false;
}

/*
  Returns true if c is part of the snake's head.
  The snake consists of these characters: "WASDx"
  Returns false otherwise.
*/
static bool is_head(char c) {
  // TODO: Implement this function.
  if(c == 'W'||c == 'A'||c == 'S'||c == 'D'){
    return true;
  }
  return false;
}

/*
  Returns true if c is part of the snake.
  The snake consists of these characters: "wasd^<v>WASDx"
*/
static bool is_snake(char c) {
  // TODO: Implement this function.
  if(is_tail(c)||is_head(c)||c == '^'||c == '<'||c == 'v'||c == '>'){
      return true;
  }
  return false;
}

/*
  Converts a character in the snake's body ("^<v>")
  to the matching character representing the snake's
  tail ("wasd").
*/
static char body_to_tail(char c) {
  // TODO: Implement this function.
  switch (c) {
      case '^':
          return 'w';
          break;
      case '<':
          return 'a';
          break;
      case 'v':
          return 's';
          break;
      case '>':
          return 'd';
          break;
  }
  return 0;
}

/*
  Converts a character in the snake's head ("WASD")
  to the matching character representing the snake's
  body ("^<v>").
*/
static char head_to_body(char c) {
  // TODO: Implement this function.
  switch (c) {
    case 'W':
        return '^';
        break;
    case 'A':
        return '<';
        break;
    case 'S':
        return 'v';
        break;
    case 'D':
        return '>';
        break;
  }
  return 0;
}

/*
  Returns cur_row + 1 if c is 'v' or 's' or 'S'.
  Returns cur_row - 1 if c is '^' or 'w' or 'W'.
  Returns cur_row otherwise.
*/
static unsigned int get_next_row(unsigned int cur_row, char c) {
  // TODO: Implement this function.
  if(c == 'v'||c == 's'||c == 'S')
      return cur_row + 1;
  if(c == '^'||c == 'w'||c == 'W')
      return cur_row - 1;
  return cur_row;
}

/*
  Returns cur_col + 1 if c is '>' or 'd' or 'D'.
  Returns cur_col - 1 if c is '<' or 'a' or 'A'.
  Returns cur_col otherwise.
*/
static unsigned int get_next_col(unsigned int cur_col, char c) {
  // TODO: Implement this function.
  if(c == '>'||c == 'd'||c == 'D')
      return cur_col + 1;
  if(c == '<'||c == 'a'||c == 'A')
      return cur_col - 1;
  return cur_col;
}

/*
  Task 4.2

  Helper function for update_game. Return the character in the cell the snake is moving into.

  This function should not modify anything.
*/
static char next_square(game_t *game, unsigned int snum) {
  // TODO: Implement this function.
  char head = game->board[game->snakes[snum].head_row][game->snakes[snum].head_col];
  unsigned int newr = get_next_row(game->snakes[snum].head_row,head);
  unsigned int newc = get_next_col(game->snakes[snum].head_col,head);
  return game->board[newr][newc];
}

/*
  Task 4.3

  Helper function for update_game. Update the head...

  ...on the board: add a character where the snake is moving

  ...in the snake struct: update the row and col of the head

  Note that this function ignores food, walls, and snake bodies when moving the head.
*/
static void update_head(game_t *game, unsigned int snum) {
  // TODO: Implement this function.
  char head = game->board[game->snakes[snum].head_row][game->snakes[snum].head_col];
  unsigned int newr = get_next_row(game->snakes[snum].head_row,head);
  unsigned int newc = get_next_col(game->snakes[snum].head_col,head);
  game->board[newr][newc] = head;
  game->board[game->snakes[snum].head_row][game->snakes[snum].head_col] = head_to_body(head);
  game->snakes[snum].head_row = newr;
  game->snakes[snum].head_col = newc;
}

/*
  Task 4.4

  Helper function for update_game. Update the tail...

  ...on the board: blank out the current tail, and change the new
  tail from a body character (^<v>) into a tail character (wasd)

  ...in the snake struct: update the row and col of the tail
*/
static void update_tail(game_t *game, unsigned int snum) {
  // TODO: Implement this function.
  unsigned int tailr = game->snakes[snum].tail_row;
  unsigned int tailc = game->snakes[snum].tail_col;
  char tail = game->board[tailr][tailc];
  unsigned int newr = get_next_row(tailr,tail);
  unsigned int newc = get_next_col(tailc,tail);
  game->board[tailr][tailc] = ' ';
  game->board[newr][newc] = body_to_tail(game->board[newr][newc]);
  game->snakes[snum].tail_row = newr;
  game->snakes[snum].tail_col = newc;
  return;
}

/* Task 4.5 */
void update_game(game_t *game, int (*add_food)(game_t *game)) {
  // TODO: Implement this function.
  for(unsigned int i = 0; i < game->num_snakes; i++){
    char next = next_square(game,i);
    unsigned int headr = game->snakes[i].head_row;
    unsigned int headc = game->snakes[i].head_col;
    if(is_snake(next) || next == '#') {
      game->board[headr][headc]= 'x';
      game->snakes[i].live = false;
    }
    else if(next == '*') {
      update_head(game,i);
      add_food(game);
    }
    else {
      update_head(game,i);
      update_tail(game,i);
    }
  }

      
  return;
}

/* Task 5.1 */
char *read_line(FILE *fp) {
  // TODO: Implement this function.
  char *line = malloc(4 * sizeof(char));
  char *a = malloc(4 * sizeof(char));
  if(!fgets(line,4,fp)){
    free(line);
    free(a);
    return NULL;
  }
  else {
    int i = 2;
    strcpy(a,line);
    while(!strchr(a,'\n')){
      a = realloc(a,i * 4 * sizeof(char));
      fgets(line,4,fp);
      strcpy(a + (i - 1) * 3,line);
      i++;
    }
    free(line);
    return a;
  }
}

/* Task 5.2 */
game_t *load_board(FILE *fp) {
  // TODO: Implement this function.
  game_t *game = malloc(sizeof(game_t));
  game->num_snakes = 0;
  game->board = NULL;
  game->snakes = NULL;
  char* read_each;
  int i=0;
  while((read_each = read_line(fp))){
    game->board = realloc(game->board,(i + 1) * sizeof(char*));
    game->board[i] = read_each;
    i++;
  }
  game->num_rows = i;
  return game;
}

/*
  Task 6.1

  Helper function for initialize_snakes.
  Given a snake struct with the tail row and col filled in,
  trace through the board to find the head row and col, and
  fill in the head row and col in the struct.
*/
static void find_head(game_t *game, unsigned int snum) {
  // TODO: Implement this function.
  int i = 0;
  for(int j = 0;j < game->num_rows;j++) {
    for(int k = 0;k < strlen(game->board[j]);k++) {
      if(is_tail(game->board[j][k])) {
        i++;
      }
      if((i-1) == snum) {
        int newr = get_next_row(j,game->board[j][k]);
        int newc = get_next_col(k,game->board[j][k]);
        while(!is_head(game->board[newr][newc])) {
          int a = newr;
          int b = newc;
          newr = get_next_row(newr,game->board[a][b]);
          newc = get_next_col(newc,game->board[a][b]);
        }
        game->snakes[snum].head_row = newr;
        game->snakes[snum].head_col = newc;
        return;
      }
    }
  }
  return;
}

/* Task 6.2 */
game_t *initialize_snakes(game_t *game) {
  // TODO: Implement this function.
  int i = 0;
  for(int j = 0;j < game->num_rows;j++) {
    for(int k = 0;k < strlen(game->board[j]);k++) {
      if(is_tail(game->board[j][k])) {
        game->snakes = realloc(game->snakes,(i + 1) * sizeof(snake_t));
        game->snakes[i].tail_row = j;
        game->snakes[i].tail_col = k;
        game->snakes[i].live = true;
        find_head(game,i);
        i++;
      }
    }
  }
  game->num_snakes = i;
  return game;
}
