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
    var board : Array<Place>;
    public var vboard : Array<Piece>;
    var choose : Choose;
    var isGameOver : Bool;

    public function new() {
        reset();
        currentPiece = E;
    }

    public function reset() {
        vboard = [for (i in 0...9) E];
        board = [for (i in 0...9) new Place(this, i)];
        choose = new Choose(this);
        isGameOver = false;
        M.redraw();
        currentPiece = playerPiece;
    }

    public function view() [
        m('#app',
            currentPiece == E ?
                m(choose)
                : m('.tictactoe', [for (place in board) m(place)])),
    ];

    public function placePiece(index) {
        if (isGameOver) return;
        vboard[index] = currentPiece;
        var state = checkWon(currentPiece);
        if (state.win) {gameOver(state.on);}
        currentPiece = currentPiece == X ? O : X;
    }

    public function gameOver(on) {
        isGameOver = true;
        haxe.Timer.delay(reset, 500);
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
    public function view() [
        m('.choose', [
            m('.piece.$X', {onclick: function() t.setPlayerPiece(X)}),
            m('.piece.$O', {onclick: function() t.setPlayerPiece(O)}),])
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
        m('.piece.${t.vboard[index]}', {onclick: change}),
    ];
    public function change() {
        if (t.vboard[index] != E) return;
        t.placePiece(index);
        t.placePiece(t.getAiTurn());
    }
}
