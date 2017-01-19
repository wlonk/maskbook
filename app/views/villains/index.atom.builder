atom_feed do |feed|
  feed.title("Maskbook Villains")
  feed.updated(@villains[0].created_at) if @villains.length > 0

  @villains.each do |villain|
    feed.entry(villain) do |entry|
      entry.title(villain.name)
      entry.subtitle(villain.drive)
      entry.content(villain.description, type: 'html')

      entry.author do |author|
        author.name(villain.user.name)
      end
    end
  end
end
