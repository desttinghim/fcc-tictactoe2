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

    var board : Array<Place>;

    public function new() {
        this.board = [for (i in 0...9) new Place(E)];
    }

    public function view() [
        m('.tictactoe#app', [for (i in board) m(i)]),
    ];

}

class Place implements Mithril{
    var piece : Piece;
    public function new(piece) {
        this.piece = piece;
    }
    public function view() [
        m('.piece.$piece', {onclick: change}),
    ];
    public function change() {
        piece = X;
    }
}
