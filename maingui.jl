# Main GUI application

using mousetrap_jll
using Mousetrap

include("./src/iotools.jl")
include("./src/status.jl")
include("./src/linesolvers.jl")
include("./src/solvers.jl")


# global variables
# (need to be global since must be modified from callbacks,
#  not sure yet how to do this properly in julia)
blabel = Label("")
infolabel = Label("")
binary = Any[nothing]


function choosefile(button::Button)
    file_chooser = FileChooser(FILE_CHOOSER_ACTION_OPEN_FILE,
				"Choose a file to open")
    on_accept!(loadfile, file_chooser)
    file_filter = FileFilter("*.txt")
    add_allowed_suffix!(file_filter, "txt")
    add_filter!(file_chooser, file_filter)
    present!(file_chooser)
    return nothing
end

function loadfile(fs::FileChooser, files::Vector{FileDescriptor})
    file = files[1]
    b = iotools.readtxt(get_path(file))
    setblabeltext(iotools.tostring(b))
    setinfolabeltext("")
    binary[1] = b
    return nothing
end

function setblabeltext(text::String)
    text = "<tt>" * text * "</tt>"
    set_text!(blabel, text)
end

function solvebinary(button::Button)
    b = binary[1]
    if isnothing(b) return nothing end
    infos = solvers.solve(b)
    setblabeltext(iotools.tostring(b))
    infotxt = ""
    for info in infos
        solver = info[1]
        cell = info[2]
        value = info[3]
        infotxt = infotxt * "Cell $cell was filled with $value using $solver" * "\n"
    end
    setinfolabeltext(infotxt)
    return nothing
end

function setinfolabeltext(text::String)
    set_text!(infolabel, text)
end

main() do app::Application

    # create the window
    window = Window(app)
    set_title!(window, "Binary puzzle solver")

    # create buttons
    loadbutton = Button()
    set_child!(loadbutton, Label("Load"))
    set_has_frame!(loadbutton, true)
    connect_signal_clicked!(choosefile, loadbutton)
    solvebutton = Button()
    set_child!(solvebutton, Label("Solve"))
    set_has_frame!(solvebutton, true)
    connect_signal_clicked!(solvebinary, solvebutton)
    button_title = Label("Actions")
    set_margin_horizontal!(button_title, 20)
    set_margin_vertical!(button_title, 10)
    buttonbox = Box(ORIENTATION_VERTICAL)
    push_back!(buttonbox, button_title)
    push_back!(buttonbox, loadbutton)
    push_back!(buttonbox, solvebutton)

    # create puzzle display
    initsize = 6
    inittext = repeat(repeat("- ", initsize) * "\n", initsize)
    inittext = "<tt>" * inittext * "</tt>"
    set_text!(blabel, inittext)
    set_justify_mode!(blabel, JUSTIFY_MODE_CENTER)
    set_margin!(blabel, 20)
    btitle = Label("The puzzle")
    set_margin_horizontal!(btitle, 20)
    set_margin_vertical!(btitle, 10)
    bbox = Box(ORIENTATION_VERTICAL)
    push_back!(bbox, btitle)
    push_back!(bbox, blabel)

    # create solving display
    set_justify_mode!(infolabel, JUSTIFY_MODE_LEFT)
    infoscroll = Viewport()
    set_child!(infoscroll, infolabel)
    set_size_request!(infoscroll, Vector2f(500, 300))
    infotitle = Label("Log")
    set_margin_horizontal!(infotitle, 20)
    set_margin_vertical!(infotitle, 10)
    infobox = Box(ORIENTATION_VERTICAL)
    push_back!(infobox, infotitle)
    push_back!(infobox, infoscroll)

    # arrange all boxes
    layout = Box(ORIENTATION_HORIZONTAL)
    push_back!(layout, buttonbox)
    push_back!(layout, bbox)
    push_back!(layout, infobox)

    # show the window
    set_child!(window, layout)
    present!(window)
end
