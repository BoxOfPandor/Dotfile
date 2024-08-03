import tkinter as tk
from tkinter import messagebox, simpledialog
import math

class PlayerSelection:
    def __init__(self, root):
        self.root = root
        self.root.title("Sélection des joueurs")

        self.num_players_label = tk.Label(root, text="Nombre de joueurs:")
        self.num_players_label.pack()

        self.num_players_entry = tk.Entry(root)
        self.num_players_entry.pack()

        self.names_frame = tk.Frame(root)
        self.names_frame.pack()

        self.names_entries = []

        self.num_players_entry.bind("<Return>", self.create_name_entries)

        self.launch_button = tk.Button(root, text="Lancer", command=self.launch_game)
        self.launch_button.pack()

    def create_name_entries(self, event):
        for entry in self.names_entries:
            entry.destroy()
        self.names_entries = []

        try:
            num_players = int(self.num_players_entry.get())
            for i in range(num_players):
                label = tk.Label(self.names_frame, text=f"Nom du joueur {i+1}:")
                label.pack()
                entry = tk.Entry(self.names_frame)
                entry.pack()
                self.names_entries.append(entry)
        except ValueError:
            pass

    def launch_game(self):
        player_names = [entry.get() for entry in self.names_entries]
        self.root.destroy()
        main(player_names)


class DartScorer:
    def __init__(self, root, player_names):
        self.root = root
        self.root.title("Dart Scorer")

        self.player_names = player_names
        self.total_points = 0
        self.turn_points = []
        self.click_points = []

        self.left_frame = tk.Frame(root)
        self.left_frame.pack(side=tk.LEFT, fill=tk.BOTH, expand=True)

        self.player_listboxes = []
        for name in player_names:
            player_frame = tk.Frame(self.left_frame)
            player_frame.pack(side=tk.LEFT, fill=tk.BOTH, expand=True)

            label = tk.Label(player_frame, text=name)
            label.pack()

            listbox = tk.Listbox(player_frame)
            listbox.pack(fill=tk.BOTH, expand=True)

            self.player_listboxes.append(listbox)

        self.canvas = tk.Canvas(root, width=600, height=600, bg="white")
        self.canvas.pack(side=tk.RIGHT)

        self.draw_target()

        self.canvas.bind("<Button-1>", self.on_click)

    def draw_target(self):
        # Dessiner les sections de la cible
        self.canvas.create_oval(50, 50, 550, 550, fill="green", outline="black")  # Double
        self.canvas.create_oval(100, 100, 500, 500, fill="white", outline="black")  # Simple
        self.canvas.create_oval(150, 150, 450, 450, fill="red", outline="black")  # Triple
        self.canvas.create_oval(200, 200, 400, 400, fill="white", outline="black")  # Simple

        # Ajouter les lignes radiales pour délimiter les sections de points
        for i in range(20):
            angle = i * 18 - 90  # Décaler de 90 degrés pour aligner le 20 en haut
            x = 300 + 250 * math.cos(math.radians(angle))
            y = 300 - 250 * math.sin(math.radians(angle))
            self.canvas.create_line(300, 300, x, y, fill="black")

        self.canvas.create_oval(275, 275, 325, 325, fill="green", outline="black")  # Inner bullseye (25 points)
        self.canvas.create_oval(290, 290, 310, 310, fill="red", outline="black")  # Bullseye (50 points)

        # Ajouter les numéros autour de la cible
        self.numbers = [20, 1, 18, 4, 13, 6, 10, 15, 2, 17, 3, 19, 7, 16, 8, 11, 14, 9, 12, 5]
        for i, num in enumerate(self.numbers):
            angle = (i * 18 + 90) + 9  # Décaler de 90 degrés pour aligner le 20 en haut et ajouter 9 degrés pour positionner entre les lignes
            x = 300 + 270 * math.cos(math.radians(angle))
            y = 300 - 270 * math.sin(math.radians(angle))
            self.canvas.create_text(x, y, text=str(num), font=("Arial", 12), fill="black")

        # Associer les clics sur la cible
        self.canvas.bind("<Button-1>", self.on_click)

    def on_click(self, event):
        # Dessiner un point noir plus petit à l'emplacement du clic
        x, y = event.x, event.y
        self.click_points.append((x, y))
        self.canvas.create_oval(x-3, y-3, x+3, y+3, fill="black", outline="black")

        # Déterminer la valeur de la section cliquée
        value = self.get_section_value(x, y)
        if value is not None:
            self.points_listbox.insert(tk.END, f"Points: {value}")

        # Vérifier si l'utilisateur a cliqué 4 fois
        if len(self.click_points) == 4:
            # Supprimer les trois derniers points noirs
            for _ in range(3):
                x, y = self.click_points.pop(0)
                self.canvas.create_oval(x-2, y-2, x+2, y+2, fill="white", outline="white")
                self.points_listbox.delete(tk.END)

            # Réinitialiser la liste des clics
            self.click_points = []

    def get_section_value(self, x, y):
        dx = x - 300
        dy = 300 - y
        distance = math.sqrt(dx**2 + dy**2)
        angle = math.degrees(math.atan2(dy, dx)) + 270
        if angle >= 360:
            angle -= 360

        section_index = int(angle // 18) % 20
        if distance <= 10:
            return 50
        elif distance <= 25:
            return 25
        elif 100 <= distance <= 150:
            return self.numbers[section_index] * 3
        elif 200 <= distance <= 250:
            return self.numbers[section_index] * 2
        elif distance <= 300:
            return self.numbers[section_index]
        else:
            return None

    def reset_game(self):
        self.total_points = 0
        self.turn_points = []
        self.points_listbox.delete(0, tk.END)
        self.canvas.delete("all")
        self.draw_target()
        self.click_points = []

def main(player_names):
    root = tk.Tk()
    app = DartScorer(root, player_names)
    root.mainloop()

if __name__ == "__main__":
    root = tk.Tk()
    player_selection = PlayerSelection(root)
    root.mainloop()