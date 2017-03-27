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

    var board : Array<Piece>;

    public function new() {
        this.board = [for (i in 0...9) E];
    }

    public function view() [
        for (i in board) m('.place', i)
    ];

}
