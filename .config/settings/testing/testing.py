import gi

gi.require_version("Gtk", "3.0")
from gi.repository import Gtk


class TreeViewFilterWindow(Gtk.Window):
    def __init__(self):
        super().__init__(title="Treeview Filter Demo")
        self.set_border_width(10)

        # Setting up the self.grid in which the elements are to be positioned
        self.grid = Gtk.Grid()
        self.grid.set_column_homogeneous(True)
        self.grid.set_row_homogeneous(True)
        self.add(self.grid)

        model = Gtk.ListBox()
        model.insert(Gtk.Button(label="Bruh 1"), -1)
        model.insert(Gtk.Label("Bruh 2"), -1)
        model.insert(Gtk.Label("Bruh 3"), -1)
        model.insert(Gtk.Label("Bruh 4"), -1)
        model.insert(Gtk.Label("Bruh 5"), -1)
        model.insert(Gtk.Label("Bruh 6"), -1)

        self.grid.attach(model, 0, 0, 1, 1)

win = TreeViewFilterWindow()
win.connect("destroy", Gtk.main_quit)
win.show_all()
Gtk.main()