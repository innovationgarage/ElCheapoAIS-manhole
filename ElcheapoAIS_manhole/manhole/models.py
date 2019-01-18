from django.db import models

class Client(models.Model):
    id = models.CharField(primary_key=True, max_length=256)
    ordering = models.IntegerField(default = 0)

    @property
    def latest_script(self):
        return self.scripts.get(ordering=self.ordering)

    def __unicode__(self):
        return self.id

class Script(models.Model):
    client = models.ForeignKey(Client, on_delete=models.CASCADE, related_name="scripts")
    content = models.TextField()
    ordering = models.IntegerField(default = 0)
    def __unicode__(self):
        return "%s: %s..." % (self.ordering, self.content[:40])

    def save(self):
        client = self.client
        client.ordering += 1
        client.save()
        self.ordering = client.ordering
        models.Model.save(self)
    
class Output(models.Model):
    script = models.OneToOneField(Script, on_delete=models.CASCADE, related_name="output")
    content = models.TextField()
    
    def __unicode__(self):
        return "%s..." % self.content[:40]
