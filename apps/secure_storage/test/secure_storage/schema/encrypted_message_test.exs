defmodule SecureStorage.Schema.EncryptedMessageTest do
  use SecureStorage.SchemaCase, async: true

  @schema SecureStorage.Schema.EncryptedMessage

  @required_fields ~w(
    short_description
    password_hint
    txt
    enc_at
    exp_at
  )a

  @encryption_algos ~w(
    plain
    aes_gcm
  )a

  @states ~w(
    new
    pending
    encryption_failed
    encrypted
    expired
    no_attempts_left
    no_reads_left
  )a

  setup_all do
    changeset = @schema.changeset(%{attempts: [%{}], reads: [%{}]})

    {:ok, changeset: changeset}
  end

  describe "changeset/2" do
    test "validates requirement of important fields", %{changeset: changeset} do
      assert validates_required?(changeset, @required_fields)
    end

    test "validates inclusion of encryption_algo", %{changeset: changeset} do
      assert validates_inclusion?(
        changeset,
        :encryption_algo,
        @encryption_algos
      )
    end

    test "validates inclusion of state", %{changeset: changeset} do
      assert validates_inclusion?(changeset, :state, @states)
    end

    test "validates length of short description", %{changeset: changeset} do
      assert validates_length?(changeset, :short_description, max: 100)
    end

    test "validates presence of fields in attempt", %{changeset: changeset} do
      [attempt_changeset] = changeset.changes.attempts
      assert validates_required?(
        attempt_changeset,
        [:ip, :at, :failure_reason]
      )
    end

    test "validates presence of fields in read", %{changeset: changeset} do
      [read_changeset] = changeset.changes.reads
      assert validates_required?(
        read_changeset,
        [:ip, :at]
      )
    end

    test "defaults max_attempts to 999", %{changeset: changeset} do
      struct = Ecto.Changeset.apply_changes(changeset)

      assert struct.max_attempts == 999
    end

    test "defaults max_reads to 999", %{changeset: changeset} do
      struct = Ecto.Changeset.apply_changes(changeset)

      assert struct.max_reads == 999
    end

    test "defaults state to :new", %{changeset: changeset} do
      struct = Ecto.Changeset.apply_changes(changeset)

      assert struct.state == :new
    end

    test "defaults encryption_algo to :aes_gcm", %{changeset: changeset} do
      struct = Ecto.Changeset.apply_changes(changeset)

      assert struct.encryption_algo == :aes_gcm
    end

    test "defaults exp_at to 2999-12-31 23:59:59Z", %{changeset: changeset} do
      struct = Ecto.Changeset.apply_changes(changeset)

      assert struct.exp_at == ~U[2999-12-31 23:59:59Z]
    end
  end

  describe "__schema__/2" do
    test "embeds many attempts" do
      assert embeds_many?(@schema, :attempts, @schema.Attempt)
    end

    test "embeds many reads" do
      assert embeds_many?(@schema, :reads, @schema.Read)
    end

    test "shows the correct database source" do
      assert @schema.__schema__(:source) == "encrypted_messages"
    end
  end
end
