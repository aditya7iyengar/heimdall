defmodule HeimdallQL.Schema.LoanTypesTest do
  use HeimdallQL.AbsintheCase

  describe "aesirs" do
    setup do
      Asguard.start_link([])

      {:ok, uuid} = Asguard.insert("raw", :key, "Description", :plaintext)

      {:ok, aesir} = Asguard.get_encrypted(uuid)

      on_exit(fn ->
        Asguard.delete(uuid)
      end)

      {:ok, aesir: aesir}
    end

    test "lists aesirs", %{aesir: aesir} do
      query = """
      query {
        aesirs {
          description
          encrypted
          encryption_algo
          uuid
        }
      }
      """

      {:ok, %{data: %{"aesirs" => [result]}}} = run(query, HeimdallQL.Schema)

      expected_result = %{
        "description" => aesir.description,
        "encrypted" => aesir.encrypted,
        "encryption_algo" => to_string(aesir.encryption_algo),
        "uuid" => aesir.uuid
      }

      assert expected_result == result
    end

    test "gets aesir", %{aesir: aesir} do
      query = """
      query {
        aesir(uuid: "#{aesir.uuid}") {
          description
          encrypted
          encryption_algo
          uuid
        }
      }
      """

      {:ok, %{data: %{"aesir" => result}}} = run(query, HeimdallQL.Schema)

      expected_result = %{
        "description" => aesir.description,
        "encrypted" => aesir.encrypted,
        "encryption_algo" => to_string(aesir.encryption_algo),
        "uuid" => aesir.uuid
      }

      assert expected_result == result
    end

    test "creates aesir" do
      raw = "raw"
      key = "key"
      description = "desc"
      encryption_algo = :plaintext

      mut = """
      mutation CreateAesir {
        createAesir(
          description: "#{description}",
          raw: "#{raw}",
          key: "#{key}",
          encryption_algo: "#{encryption_algo}"
      ) {
          description
          encrypted
          encryption_algo
        }
      }
      """

      {:ok, %{data: %{"createAesir" => result}}} = run(mut, HeimdallQL.Schema)

      expected_result = %{
        "description" => description,
        # NOTE: encrypted == raw because of plain text
        "encrypted" => raw,
        "encryption_algo" => to_string(encryption_algo)
      }

      on_exit(fn ->
        [aesir] = Asguard.search(description)
        Asguard.delete(aesir.uuid)
      end)

      assert expected_result == result
    end
  end
end
