import java.math.BigInteger
import java.net.InetAddress

fun map(cidr: String): Pair<Int, Int> {
    val (network, prefixLength) = cidr.split("/").let {
        it[0] to it[1].toInt()
    }

    val addressBytes = InetAddress.getByName(network).address
    val addressAsInt = BigInteger(1, addressBytes).toInt()

    val mask = (1.shl(32) - 1).shl(32 - prefixLength)
    val lowerBound = addressAsInt and mask
    val upperBound = lowerBound or mask.inv()

    return Pair(lowerBound, upperBound)
}
