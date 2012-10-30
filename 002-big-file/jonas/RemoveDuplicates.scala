import scala.io.Source
import java.security.MessageDigest
import scala.math.BigInt
import scala.collection.mutable.Set
import java.io.PrintWriter

val begin = System.currentTimeMillis

val digester = MessageDigest.getInstance("MD5")
val hashes = Set[String]()
val output = new PrintWriter("saida.txt")
def hash(line : String) = BigInt(digester.digest(line.getBytes)).toString(16)

Source.fromFile("big-file-2.txt").getLines.foreach { line =>
  val lineHash = hash(line)
  if (!(hashes contains (lineHash))) {
    hashes += lineHash
    output.println(line)
  }
}
output.close

println("Demorou: " + (System.currentTimeMillis - begin))

