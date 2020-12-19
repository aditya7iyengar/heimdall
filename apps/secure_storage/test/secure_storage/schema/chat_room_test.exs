defmodule SecureStorage.Schema.ChatRoomTest do
  use SecureStorage.SchemaCase, async: true

  @schema SecureStorage.Schema.ChatRoom

  @required_fields ~w(
    title
    allows_text
    allows_audio
    allows_video
    exp_at
    max_participants
  )a

  setup_all do
    changeset = @schema.changeset(%{title: "Title", participants: [%{}]})

    {:ok, changeset: changeset}
  end

  describe "changeset/2" do
    test "validates requirement for fields", %{changeset: changeset} do
      assert validates_required?(changeset, @required_fields)
    end

    test "validates length of title", %{changeset: changeset} do
      assert validates_length?(changeset, :title, max: 100)
    end

    test "validates required fields in participant", %{changeset: changeset} do
      [participant_changeset] = changeset.changes.participants

      assert validates_required?(
               participant_changeset,
               [:ip, :name, :joined_at]
             )
    end

    test "defaults max_participants to 5", %{changeset: changeset} do
      struct = Ecto.Changeset.apply_changes(changeset)

      assert struct.max_participants == 5
    end

    test "defaults allows_text to true", %{changeset: changeset} do
      struct = Ecto.Changeset.apply_changes(changeset)

      assert struct.allows_text == true
    end

    test "defaults allows_audio to true", %{changeset: changeset} do
      struct = Ecto.Changeset.apply_changes(changeset)

      assert struct.allows_audio == true
    end

    test "defaults allows_video to true", %{changeset: changeset} do
      struct = Ecto.Changeset.apply_changes(changeset)

      assert struct.allows_video == true
    end

    test "defaults exp_at to 2999-12-31 23:59:59Z", %{changeset: changeset} do
      struct = Ecto.Changeset.apply_changes(changeset)

      assert struct.exp_at == ~U[2999-12-31 23:59:59Z]
    end
  end

  describe "__schema__/2" do
    test "embeds many participants" do
      assert embeds_many?(@schema, :participants, @schema.Participant)
    end

    test "shows the correct database source" do
      assert @schema.__schema__(:source) == "chat_rooms"
    end
  end
end
