import java.math.BigInteger
import java.net.InetAddress

fun map(cidr: String): Pair<Long, Long> {
    val (ip, prefixLength) = cidr.split("/")
    val ipInt = ByteBuffer.wrap(InetAddress.getByName(ip).address).int.toUInt()
    val mask = (0xFFFFFFFF.toUInt() shl (32 - prefixLength.toInt()))

    val network = ipInt and mask
    val broadcast = network or mask.inv()

    return Pair(network.toLong(), broadcast.toLong()) // Convert to Int for storage
}
