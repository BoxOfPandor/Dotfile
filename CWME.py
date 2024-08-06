import tkinter as tk
from tkinter import simpledialog

class ChatApp:
    def __init__(self, root):
        self.root = root
        self.root.title("Chat App")

        self.chats = {}  # Dictionnaire pour stocker les messages de chaque discussion
        self.interlocutors = {}  # Dictionnaire pour stocker les noms des interlocuteurs
        self.is_user_turn = True  # Variable pour suivre si c'est l'utilisateur ou l'interlocuteur qui parle

        # Frame pour la liste des discussions
        self.left_frame = tk.Frame(root)
        self.left_frame.pack(side=tk.LEFT, fill=tk.Y)

        self.chat_listbox = tk.Listbox(self.left_frame)
        self.chat_listbox.pack(side=tk.TOP, fill=tk.BOTH, expand=True)
        self.chat_listbox.bind("<<ListboxSelect>>", self.on_chat_select)  # Liaison de la sélection de discussion

        self.button_frame = tk.Frame(self.left_frame)
        self.button_frame.pack(side=tk.BOTTOM, fill=tk.X)

        self.new_chat_button = tk.Button(self.button_frame, text="Créer", command=self.new_chat)
        self.new_chat_button.pack(side=tk.LEFT)

        self.delete_chat_button = tk.Button(self.button_frame, text="Supprimer", command=self.delete_chat)
        self.delete_chat_button.pack(side=tk.RIGHT)

        # Frame pour les messages
        self.right_frame = tk.Frame(root)
        self.right_frame.pack(side=tk.RIGHT, fill=tk.BOTH, expand=True)

        self.messages_text = tk.Text(self.right_frame, state=tk.DISABLED)
        self.messages_text.pack(side=tk.TOP, fill=tk.BOTH, expand=True)

        # Ajouter des tags pour aligner le texte
        self.messages_text.tag_configure("left", justify='left')
        self.messages_text.tag_configure("right", justify='right')

        self.entry_frame = tk.Frame(self.right_frame)
        self.entry_frame.pack(side=tk.BOTTOM, fill=tk.X)

        self.switch_button = tk.Button(self.entry_frame, text="Switch", command=self.switch_speaker)
        self.switch_button.pack(side=tk.LEFT)

        self.message_entry = tk.Entry(self.entry_frame)
        self.message_entry.pack(side=tk.LEFT, fill=tk.X, expand=True)
        self.message_entry.bind("<Return>", self.send_message)  # Liaison de la touche "Entrée"

        self.send_button = tk.Button(self.entry_frame, text="Envoyer", command=self.send_message, state=tk.DISABLED)
        self.send_button.pack(side=tk.RIGHT)

    def new_chat(self):
        chat_name = simpledialog.askstring("Nouvelle Discussion", "Nom de la discussion:")
        if chat_name:
            interlocutor_name = simpledialog.askstring("Nouvelle Discussion", "Nom de l'interlocuteur:")
            if interlocutor_name:
                self.chat_listbox.insert(tk.END, chat_name)
                self.chats[chat_name] = []  # Initialiser une liste de messages pour la nouvelle discussion
                self.interlocutors[chat_name] = interlocutor_name  # Stocker le nom de l'interlocuteur

    def delete_chat(self):
        selected_index = self.chat_listbox.curselection()
        if selected_index:
            selected_chat = self.chat_listbox.get(selected_index)
            del self.chats[selected_chat]  # Supprimer les messages de la discussion
            del self.interlocutors[selected_chat]  # Supprimer le nom de l'interlocuteur
            self.chat_listbox.delete(selected_index)  # Supprimer la discussion de la liste
            self.messages_text.config(state=tk.NORMAL)
            self.messages_text.delete(1.0, tk.END)  # Effacer les messages affichés
            self.messages_text.config(state=tk.DISABLED)
            self.send_button.config(state=tk.DISABLED)

    def on_chat_select(self, event):
        if self.chat_listbox.curselection():
            self.send_button.config(state=tk.NORMAL)
            selected_chat = self.chat_listbox.get(self.chat_listbox.curselection())
            self.display_messages(selected_chat)
        else:
            self.send_button.config(state=tk.DISABLED)

    def display_messages(self, chat_name):
        self.messages_text.config(state=tk.NORMAL)
        self.messages_text.delete(1.0, tk.END)
        for message in self.chats[chat_name]:
            if message.startswith("Vous:"):
                self.messages_text.insert(tk.END, message + "\n", "left")
            else:
                self.messages_text.insert(tk.END, message + "\n", "right")
        self.messages_text.config(state=tk.DISABLED)

    def send_message(self, event=None):
        if not self.chat_listbox.curselection():
            return
        message = self.message_entry.get()
        if message:
            selected_chat = self.chat_listbox.get(self.chat_listbox.curselection())
            if self.is_user_turn:
                self.chats[selected_chat].append(f"Vous: {message}")
            else:
                interlocutor_name = self.interlocutors[selected_chat]
                self.chats[selected_chat].append(f"{message} : {interlocutor_name}")
            self.display_messages(selected_chat)
            self.message_entry.delete(0, tk.END)

    def switch_speaker(self):
        self.is_user_turn = not self.is_user_turn
        if self.is_user_turn:
            self.switch_button.config(text="Switch to Interlocutor")
        else:
            self.switch_button.config(text="Switch to User")

if __name__ == "__main__":
    root = tk.Tk()
    app = ChatApp(root)
    root.mainloop()