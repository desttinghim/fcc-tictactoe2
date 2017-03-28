import js.Browser;
import js.html.Element;
import mithril.M;

using Lambda;

class Main {
    static function main() {M.mount(Browser.document.body, new TicTacToe());}
}

@:enum abstract Piece(String) to String {
    var X = "cross";
    var O = "knot";
    var E = "empty";
}

class TicTacToe implements Mithril {

    public var currentPiece : Piece;
    var playerPiece : Piece = E;
    var board : Board;
    public var vboard : Array<Piece>;
    var choose : Choose;
    var isGameOver : Bool;
    var line : Line;

    public function new() {
        reset();
        currentPiece = E;
    }

    public function reset() {
        line = new Line(-1);
        vboard = [for (i in 0...9) E];
        board = new Board(this);
        choose = new Choose(this);
        isGameOver = false;
        M.redraw();
        currentPiece = playerPiece;
    }

    public function view() [
        m('#app', [
            currentPiece == E
            ? m(choose)
            : m('.tictactoe', m(board),
            isGameOver ? m(line) : [])
    ])];

    public function placePiece(index) {
        if (isGameOver) return;
        vboard[index] = currentPiece;
        var state = checkWon(currentPiece);
        if (state.win) {gameOver(state.on);}
        currentPiece = currentPiece == X ? O : X;
    }

    public function gameOver(on) {
        isGameOver = true;
        line = new Line(on);
        M.redraw();
        haxe.Timer.delay(reset, 1000);
    }

    public function getAiTurn() {
        return vboard.indexOf(E);
    }

    public function setPlayerPiece(piece) {
        currentPiece = piece;
        playerPiece = piece;
    }

    // Array of all the different winning combos
    var wins = [
    [true, true, true, false, false, false, false, false, false,],
    [false, false, false,true, true, true,false, false, false,],
    [false, false, false,false, false, false,true, true, true,],
    [true, false, false,true, false, false,true, false, false,],
    [false, true, false,false, true, false,false, true, false,],
    [false, false, true,false, false, true,false, false, true,],
    [true, false, false,false, true, false,false, false, true,],
    [false, false, true,false, true, false,true, false, false,],];

    function checkWon(piece) {

        var boardState = vboard.map(function(item) {return item == piece;});

        for (a in 0...wins.length) {
            var arr = wins[a];
            var acc = true;
            for (i in 0...arr.length) {
                if (acc && arr[i] && !boardState[i]) acc = false;
            }
            if (acc) return {win: true, on: a};
        }
        return {win: false, on: -1};
    }

}

class Choose implements Mithril {
    var t : TicTacToe;
    public function new(t) {this.t = t;}
    function setX() {t.setPlayerPiece(X);}
    function setO() {t.setPlayerPiece(O);}
    public function view() [
        m('.choose', [
            m('.piece.$X', {ontouch: setX, onclick: setX }),
            m('.piece.$O', {ontouch: setO, onclick: setO}),])
    ];
}

class Board implements Mithril {
    var t : TicTacToe;
    var places : Array<Place>;
    public function new(t) {
        this.t = t;
        places = [for (index in 0...t.vboard.length) new Place(t, index)];
    }
    public function view() [
    for(place in places) m(place)
    ];
}

class Place implements Mithril{
    var t : TicTacToe;
    var index : Int;
    public function new(t, index) {
        this.t = t;
        this.index = index;
    }
    public function view() [
        m('.piece.${t.vboard[index]}', {ontouch: change, onclick: change}),
    ];
    public function change() {
        if (t.vboard[index] != E) return;
        t.placePiece(index);
        t.placePiece(t.getAiTurn());
    }
}


class Line implements Mithril {
    var index : Int;
    public function new(index) {
        this.index = index;
    }
    public function view() [
        m('.line.l$index')
    ];
}
