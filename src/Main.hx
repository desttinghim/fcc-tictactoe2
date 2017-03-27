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
    var board : Array<Place>;
    var choose : Choose;

    public function new() {
        this.choose = new Choose(this);
        this.board = [for (i in 0...9) new Place(this, E)];
        currentPiece = E;
    }

    public function view() [
        m('#app',
            currentPiece == E ?
                m(choose)
                : m('.tictactoe', [for (i in board) m(i)])),
    ];

}

class Choose implements Mithril {
    var t : TicTacToe;
    public function new(t) {this.t = t;}
    public function view() [
        m('.choose', [
            m('.piece.$X', {onclick: function() t.currentPiece = X}),
            m('.piece.$O', {onclick: function() t.currentPiece = O}),])
    ];
}

class Place implements Mithril{
    var t : TicTacToe;
    var piece : Piece;
    public function new(t, piece) {
        this.t = t;
        this.piece = piece;
    }
    public function view() [
        m('.piece.$piece', {onclick: change}),
    ];
    public function change() {
        piece = t.currentPiece;
        t.currentPiece = t.currentPiece == X ? O : X;
    }
}
