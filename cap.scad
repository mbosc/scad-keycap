use <c:/Users/mbosc/AppData/Local/Microsoft/Windows/Fonts/Helvetica.ttf>
use <c:/Users/mbosc/AppData/Local/Microsoft/Windows/Fonts/NotoSansSymbols-VariableFont_wght.ttf>
use <c:/Users/mbosc/AppData/Local/Microsoft/Windows/Fonts/symbola.otf>

infix = 0.6;
displx = 4;
disply = 5;

base_font_size = 10 * .75;
side_font_size = 7 * .75 * .75;
font = "Helvetica";
fallback_font = "DejaVu Sans:style=Bold";
fallback_fallback_font = "Symbola:style=Regular";
fallback_fallback_characters = "⏩🔉🔊⏵⤒⤓";
function comp_font(string) = len(search(string, fallback_fallback_characters)) > 0 ? fallback_fallback_font : (len([ for (c = string) if (ord(c) > 200) 1]) > 0) ? fallback_font : font;
    
module gen_legend(legend, infix, base_font_size) {
    if (len(legend)!=0){

        if (is_list(legend)){
            translate([-0.5, -1.5, 0])
                gen_legend(legend[0], infix, base_font_size);
            translate([3, 2, 0])
                gen_legend(legend[1], infix, base_font_size * .8);       
        
        } else {
        translate([0, 0, 7 - infix])
            linear_extrude(2*infix)
                text(legend, halign="center", valign="center", font=comp_font(legend), size=(len(legend)==1 ? 1: 0.6) * base_font_size);
        }
    }
    
}

function is_number(s) = ord(s) >= 48 && ord(s) <= 57;
function is_parenth(s) = len(search(s, "[{()}]🔉🔊⤒ ⤓⌫⌦\\|@!#$%&"))>0;

module small_legend(sft_legend, infix, side_font_size) {
    
    if (len(sft_legend)!=0) {
        if (is_list(sft_legend)) {
            translate([-1.5, -1.5, 0])
                small_legend(sft_legend[0], infix, side_font_size);
            translate([1, .5, 0])
                small_legend(sft_legend[1], infix, side_font_size);
        } else {        
                translate([-displx, disply, 7 - infix])
                linear_extrude(2*infix)
                    text(sft_legend, halign="center", valign="center", 
                    font=comp_font(sft_legend),
                    size=side_font_size * (is_number(sft_legend) ? 0.9 : is_parenth(sft_legend) ? 0.8 : (len(sft_legend)==1 ? 1: 0.7)));
            }
    }
}

module simple_key(legend, sft_legend, infix, base_font_size, side_font_size, mode){
    // mode 1 for embossed legends, mode 0 for extruded legends
    
    if (mode == 1){
        difference() {
            difference() {
                translate([-9,-9,0])
                    import("D:/printable/originals/roundcapfx_fixed.stl");
                gen_legend(legend, infix, base_font_size);
            }
            small_legend(sft_legend, infix, side_font_size);
        }
    }
    else if (mode == 0){
        union() {
            difference() {
                translate([-9,-9,0])
                    import("D:/printable/originals/roundcapfx_fixed.stl");
                gen_legend(legend, infix, base_font_size);
            }
            small_legend(sft_legend, infix, side_font_size);
        }
    }
    if (len(search(legend[0], "fj")) > 0) {
        translate([0, -5.5, 7 - infix])
            cube(size=[4, 0.7, 2], center=true);
    }
    
}

simple_keys = [
            ["q", "⇱"], 
            ["w", "↑"],
            ["e", "⇲"], ["r", "⤒"], ["t",  ""], ["y",  ""], ["u", "-"], ["o", "["], ["p", "]"],
               ["a", "←"], ["s", "↓"], ["d", "→"], ["f", "⤓"], ["g",  ""], ["h",  ""], ["j", "_"], ["k", "+"], ["l", "{"],
                ["z", ["1", "!"]], ["x", ["2", "@"]], ["c", ["3", "#"]], ["v", ["4", "$"]], ["b", ["5", "%"]], ["n", ["6", "^"]], ["m", ["7", "&"]], [",", ["8", "*"]], [".", ["9", "("]], ["/", ["0", ")"]],
            [" ", "⌫"], [" ", "⌦"], ["i", "="],
            ["k", "+"], ["s", "↓"] , ["g",  ""],["c", ["3", "#"]]
               ["bksp", ""], ["⇣", ""], ["⇡", ""], ["alt", ""], ["meta", ""], ["void", ""], ["ctrl", ""], ["void", ""], 
               ["alt", "⏩"], ["meta", "🔉"], ["esc", "🔊"], 
            ["entr", "⏵"], 
            [[";",":"], "}"], 
            [["'", "\""],["\\","|"]],
             ["tab", ["`","~"]],
            ["shift", "ent"], ["shift", "esc"]
               ];

//an excellent source for symbols https://wincent.com/wiki/Unicode_representations_of_modifier_keys

gcounter = 0;
for(i = [0 : len(simple_keys) - 1]) {
    legend = simple_keys[i][0];
    sft_legend = simple_keys[i][1];
    counter = gcounter + i;
    
    translate([19*(counter%5), -19*floor(counter/5), 0]) 
        simple_key(legend, sft_legend, infix, base_font_size, side_font_size, 1);
    
}




