import js.Browser;
import js.html.Element;
import mithril.M;

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
    var playerPiece : Piece;
    var board : Array<Place>;
    public var vboard : Array<Piece>;
    var choose : Choose;

    public function new() {
        this.choose = new Choose(this);
        this.vboard = [for (i in 0...9) E];
        this.board = [for (i in 0...9) new Place(this, i)];
        currentPiece = E;
    }

    public function view() [
        m('#app',
            currentPiece == E ?
                m(choose)
                : m('.tictactoe', [for (i in board) m(i)])),
    ];

    public function placePiece(index) {
        vboard[index] = currentPiece;
        currentPiece = currentPiece == X ? O : X;
    }

    public function getAiTurn() {
        return vboard.indexOf(E);
    }

    public function setPlayerPiece(piece) {
        currentPiece = piece;
        playerPiece = piece;
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
